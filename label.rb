#!/usr/bin/env ruby

require "barby/barcode/code_128"
require "barby/barcode/qr_code"
require "barby/outputter/prawn_outputter"

class DeviceLabel
  PT_PER_MM = 841.89/297 # ~2.835

  # footer                          String
  # size    [width, height]         in mm
  # margin  [horizontal, vertical]  in mm
  # font_size                       in pt
  # font_family                     String
  def initialize(mac, url, size: [148,210], margin: [30,25], font_size: 9, font_family: "Helvetica")
  def initialize(mac, url, footer: nil, size: [148,210], margin: [30,25], font_size: 9, font_family: "Helvetica")
    @mac          = mac
    @url          = url
    @footer       = footer
    @font_size    = font_size
    @font_family  = font_family

    @page_size    = size.map &method(:mm2pt)
    @margin       = margin.map &method(:mm2pt)
  end

  def render
    annotate_barcode!
    annotate_mac!
    annotate_qrcode!
    annotate_footer! if @footer

    document.render
  end

  def document
    @document ||= begin
      options = {
        page_size:    @page_size,
        margin:       @margin.reverse, #!
        compress:     true,
        page_layout:  @page_size[0] > @page_size[1] ? :landscape : :portrait,
      }

      Prawn::Document.new(options).tap {|doc|
        doc.font_size @font_size
      }
    end
  end

private

  def mm2pt(mm)
    (mm * PT_PER_MM).round.to_f
  end

  def inner_dim
    @inner_dim ||= {
      width:  @page_size[0] - 2*@margin[0],
      height: @page_size[1] - 2*@margin[1],
    }
  end

  def element_heights
    @element_heights ||= {
      barcode:  65.0,
      mac:      inner_dim[:height] - 65 - inner_dim[:width] - 24,
      qr_code:  inner_dim[:width],
      footer:   24.0,
    }
  end

  def element_ypos
    @element_ypos ||= {
      barcode:  element_heights[:footer] + element_heights[:qr_code] + element_heights[:mac],
      mac:      element_heights[:footer] + element_heights[:qr_code],
      qr_code:  element_heights[:footer],
      footer:   0.0,
    }
  end

  def annotate_barcode!
    add_barcode :barcode, Barby::Code128B.new(@mac)
  end

  def annotate_mac!
    document.font_size(30) {
      document.text_box @mac,
        at:     [0, element_ypos[:mac] + element_heights[:mac]],
        width:  inner_dim[:width],
        height: element_heights[:mac],
        align:  :center,
        valign: :center
    }
  end

  def annotate_qrcode!
    add_barcode :qrcode, Barby::QrCode.new(@url, level: :m)
  end

  def annotate_footer!
    document.text_box @footer,
      at:       [0, element_ypos[:footer] + element_heights[:footer]],
      width:    inner_dim[:width],
      height:   element_heights[:footer],
      align:    :right,
      valign:   :bottom
  end

  def add_barcode(elem, code)
    o = Barby::PrawnOutputter.new(code)
    o.annotate_pdf document,
      height:   element_heights[elem],
      margin:   0,
      unbleed:  0,
      xdim:     inner_dim[:width]/o.width,
      y:        element_ypos[elem]
  end
end

if $0 == __FILE__
  ARGV.each do |arg|
    mac   = arg.strip
    url   = sprintf "http://mgmt.ffhb.de/#/n/%s", mac.gsub(/:/, "")

    label = DeviceLabel.new(mac, url).render
    fname = sprintf "%s.pdf", mac.gsub(/\W/, "")

    File.open(fname, "w") {|f| f.write label }
    printf "Written %s to %s\n", mac, fname
  end
end
