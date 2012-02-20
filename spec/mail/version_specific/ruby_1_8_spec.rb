# encoding: utf-8
require 'spec_helper'

if RUBY_VERSION < '1.9'
  module KcodeMacros
    def examples_for_kcode(given_kcode, &block)
      ctx = context "$KCODE = '#{given_kcode}'" do
        around do |example|
          begin
            last_kcode, $KCODE = $KCODE, given_kcode
            example.run
          ensure
            $KCODE = last_kcode
          end
        end
      end
      ctx.module_eval(&block)
    end
  end

  describe Mail::RubyVer do
    extend KcodeMacros

    describe ".encode_for_charset" do
      wave_dash = "\xE3\x80\x9C"
      let(:wave_dash) { wave_dash }

      full_width_tilde = "\xEF\xBD\x9E"
      let(:full_width_tilde) { full_width_tilde }

      full_width_tilde_iso2022jp = "\e\x24\x42\x21\x41\e\x28\x42"
      let(:full_width_tilde_iso2022jp) { full_width_tilde_iso2022jp }

      full_width_tilde_sjis = "\x81\x60"
      let(:full_width_tilde_sjis) { full_width_tilde_sjis }

      full_width_tilde_eucjp = "\xA1\xC1"
      let(:full_width_tilde_eucjp) { full_width_tilde_eucjp }

      examples_for_kcode('u') do
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

      examples_for_kcode('s') do
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

      examples_for_kcode('e') do
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
