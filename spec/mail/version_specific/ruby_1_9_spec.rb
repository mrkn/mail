# encoding: utf-8
require 'spec_helper'

if RUBY_VERSION >= '1.9'
  describe Mail::RubyVer do
    describe ".encode_for_charset" do
      wave_dash = "\xE3\x80\x9C"
      let(:wave_dash) { wave_dash }

      full_width_tilde = "\xEF\xBD\x9E"
      let(:full_width_tilde) { full_width_tilde }

      full_width_tilde_iso2022jp = "\e\x24\x42\x21\x41\e\x28\x42".force_encoding('ISO-2022-JP')
      let(:full_width_tilde_iso2022jp) { full_width_tilde_iso2022jp }

      full_width_tilde_sjis = "\x81\x60".force_encoding('Shift_JIS')
      let(:full_width_tilde_sjis) { full_width_tilde_sjis }

      full_width_tilde_eucjp = "\xA1\xC1".force_encoding('EUC-JP')
      let(:full_width_tilde_eucjp) { full_width_tilde_eucjp }

      context 'source encoding is UTF-8' do
        context 'destination charset is UTF-8' do
          context "source string contains WAVE DASH (U+301C)" do
            it "should convert WAVE DASH to FULL WIDTH TILDE" do
              Mail::RubyVer.encode_for_charset(wave_dash, "UTF-8").should eq full_width_tilde
            end
          end

          context "source string contains FULL WIDTH TILDE (U+FF5E)" do
            it "should do nothing" do
              Mail::RubyVer.encode_for_charset(full_width_tilde, "UTF-8").should eq full_width_tilde
            end
          end
        end

        context 'destination charset is ISO-2022-JP' do
          context "source string contains WAVE DASH (U+301C)" do
            it "should convert WAVE DASH to #{full_width_tilde_iso2022jp.dump}" do
              Mail::RubyVer.encode_for_charset(wave_dash, "ISO-2022-JP").should eq full_width_tilde_iso2022jp
            end
          end

          context "source string contains FULL WIDTH TILDE (U+FF5E)" do
            it "should convert FULL WIDTH TILDE to #{full_width_tilde_iso2022jp.dump}" do
              Mail::RubyVer.encode_for_charset(full_width_tilde, "ISO-2022-JP").should eq full_width_tilde_iso2022jp
            end
          end
        end

        context 'destination charset is Shift_JIS' do
          context "source string contains WAVE DASH (U+301C)" do
            it "should convert WAVE DASH to #{full_width_tilde_sjis.dump}" do
              Mail::RubyVer.encode_for_charset(wave_dash, "Shift_JIS").should eq full_width_tilde_sjis
            end
          end

          context "source string contains FULL WIDTH TILDE (U+FF5E)" do
            it "should convert FULL WIDTH TILDE to #{full_width_tilde_sjis.dump}" do
              Mail::RubyVer.encode_for_charset(wave_dash, "Shift_JIS").should eq full_width_tilde_sjis
            end
          end
        end

        context 'destination charset is EUC-JP' do
          context "source string contains WAVE DASH (U+301C)" do
            it "should convert WAVE DASH to #{full_width_tilde_eucjp.dump}" do
              Mail::RubyVer.encode_for_charset(wave_dash, "EUC-JP").should eq full_width_tilde_eucjp
            end
          end

          context "source string contains FULL WIDTH TILDE (U+FF5E)" do
            it "should convert FULL WIDTH TILDE to #{full_width_tilde_eucjp.dump}" do
              Mail::RubyVer.encode_for_charset(full_width_tilde, "EUC-JP").should eq full_width_tilde_eucjp
            end
          end
        end
      end

      context 'source encoding is Shift_JIS' do
        context 'destination charset is UTF-8' do
          context "source string contains #{full_width_tilde_sjis.dump}" do
            it "should convert #{full_width_tilde_sjis.dump} to FULL WIDTH TILDE" do
              Mail::RubyVer.encode_for_charset(full_width_tilde_sjis, "UTF-8").should eq full_width_tilde
            end
          end
        end

        context 'destination charset is ISO-2022-JP' do
          context "source string contains #{full_width_tilde_sjis.dump}" do
            it "should convert #{full_width_tilde_sjis.dump} to #{full_width_tilde_iso2022jp.dump}" do
              Mail::RubyVer.encode_for_charset(full_width_tilde_sjis, "ISO-2022-JP").should eq full_width_tilde_iso2022jp
            end
          end
        end

        context 'destination charset is EUC-JP' do
          context "source string contains #{full_width_tilde_sjis.dump}" do
            it "should convert #{full_width_tilde_sjis.dump} to #{full_width_tilde_eucjp.dump}" do
              Mail::RubyVer.encode_for_charset(full_width_tilde_sjis, "EUC-JP").should eq full_width_tilde_eucjp
            end
          end
        end
      end

      context 'source encoding is EUC-JP' do
        context 'destination charset is UTF-8' do
          context "source string contains #{full_width_tilde_eucjp.dump}" do
            it "should convert #{full_width_tilde_eucjp.dump} to FULL WIDTH TILDE" do
              Mail::RubyVer.encode_for_charset(full_width_tilde_eucjp, "UTF-8").should eq full_width_tilde
            end
          end
        end

        context 'destination charset is ISO-2022-JP' do
          context "source string contains #{full_width_tilde_eucjp.dump}" do
            it "should convert #{full_width_tilde_eucjp.dump} to #{full_width_tilde_iso2022jp.dump}" do
              Mail::RubyVer.encode_for_charset(full_width_tilde_eucjp, "ISO-2022-JP").should eq full_width_tilde_iso2022jp
            end
          end
        end

        context 'destination charset is Shift_JIS' do
          context "source string contains #{full_width_tilde_eucjp.dump}" do
            it "should convert #{full_width_tilde_eucjp.dump} to #{full_width_tilde_eucjp.dump}" do
              Mail::RubyVer.encode_for_charset(full_width_tilde_eucjp, "Shift_JIS").should eq full_width_tilde_sjis
            end
          end
        end
      end
    end
  end
end
