#!/usr/bin/env/ruby

lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'solareventcalculator'
gem 'minitest'
require 'minitest/autorun'

describe SolarEventCalculator, 'Test the sunset algorithm' do
  before do
    @date = Date.parse('2008-11-01') # 01 November 2008 (DST)
    @calc = SolarEventCalculator.new(
      @date, BigDecimal.new('39.9537'),
      BigDecimal.new('-75.7850')
    )
  end

  it 'returns correct longitude hour' do
    assert_equal(@calc.compute_lnghour, BigDecimal.new('-5.0523'))
  end

  it 'returns correct longitude hour' do
    assert_equal(
      @calc.compute_longitude_hour(false),
      BigDecimal.new('306.9605')
    )
  end

  it 'returns correct sunset mean anomaly' do
    assert_equal(
      @calc.compute_sun_mean_anomaly(BigDecimal.new('306.9605')),
      BigDecimal.new('299.2513')
    )
  end

  it "returns correct sunset's sun true longitude" do
    assert_equal(
      @calc.compute_sun_true_longitude(BigDecimal.new('299.2513')),
      BigDecimal.new('220.1966')
    )
  end

  it "returns correct sunset's right ascension" do
    assert_equal(
      @calc.compute_right_ascension(BigDecimal.new('220.1966')),
      BigDecimal.new('37.7890')
    )
  end

  it "returns correct sunset's right ascension quadrant" do
    assert_equal(
      @calc.put_ra_in_correct_quadrant(BigDecimal.new('220.1966')),
      BigDecimal.new('14.5193')
    )
  end

  it 'returns correct sunset sin sun declination' do
    assert_equal(
      @calc.compute_sine_sun_declination(BigDecimal.new('220.1966')),
      BigDecimal.new('-0.2568')
    )
  end

  it 'returns correct sunset cosine sun declination' do
    assert_equal(@calc.compute_cosine_sun_declination(-0.2541), 0.9672)
  end

  it 'returns correct sunset cosine sun local hour' do
    assert_equal(
      @calc.compute_cosine_sun_local_hour(BigDecimal.new('220.1966'), 96),
      BigDecimal.new('0.0815')
    )
  end

  it 'returns correct sunset local hour angle' do
    assert_equal(
      @calc.compute_local_hour_angle(BigDecimal.new('0.0815'), false),
      BigDecimal.new('5.6883')
    )
  end

  it 'returns correct sunset local mean time' do
    trueLong = BigDecimal.new('220.1966')
    longHour = BigDecimal.new('-5.0523')
    localHour = BigDecimal.new('5.6883')
    t = BigDecimal.new('306.9605')
    assert_equal(
      @calc.compute_local_mean_time(trueLong, longHour, t, localHour),
      BigDecimal.new('22.4675')
    )
  end

  it 'returns correct UTC civil sunset time' do
    assert_equal(
      @calc.compute_utc_civil_sunset,
      DateTime.parse("#{@date.strftime}T22:28:00-00:00")
    )
  end

  it 'returns correct UTC official sunset time' do
    assert_equal(
      @calc.compute_utc_official_sunset,
      DateTime.parse("#{@date.strftime}T21:59:00-00:00")
    )
  end

  it 'returns correct UTC nautical sunset time' do
    assert_equal(
      @calc.compute_utc_nautical_sunset,
      DateTime.parse("#{@date.strftime}T23:00:00-00:00")
    )
  end

  it 'returns correct UTC astronomical sunset time' do
    assert_equal(
      @calc.compute_utc_astronomical_sunset,
      DateTime.parse("#{@date.strftime}T23:31:00-00:00")
    )
  end

  it "returns correct 'America/New_York' offical sunset time" do
    assert_equal(
      @calc.compute_official_sunset('America/New_York'),
      DateTime.parse("#{@date.strftime}T17:59:00-04:00")
    )
  end

  it "returns correct 'America/New_York' civil sunset time" do
    assert_equal(
      @calc.compute_civil_sunset('America/New_York'),
      DateTime.parse("#{@date.strftime}T18:28:00-04:00")
    )
  end

  it "returns correct 'America/New_York' nautical sunset time" do
    assert_equal(
      @calc.compute_nautical_sunset('America/New_York'),
      DateTime.parse("#{@date.strftime}T19:00:00-04:00")
    )
  end

  it "returns correct 'America/New_York' astronomical sunset time" do
    assert_equal(
      @calc.compute_astronomical_sunset('America/New_York'),
      DateTime.parse("#{@date.strftime}T19:31:00-04:00")
    )
  end
end

describe SolarEventCalculator,
         "test the math for areas where the sun doesn't set" do
  it 'returns correct time' do
    date = Date.parse('2008-04-25') # 25 April 2008
    calc = SolarEventCalculator.new(
      date, BigDecimal.new('64.8378'),
      BigDecimal.new('-147.7164')
    )
    assert_nil(calc.compute_utc_nautical_sunset, nil)
  end

  it 'returns correct time' do
    date = Date.parse('2008-04-25') # 25 April 2008
    calc = SolarEventCalculator.new(
      date, BigDecimal.new('64.8378'),
      BigDecimal.new('-147.7164')
    )
    assert_nil(calc.compute_utc_nautical_sunset, nil)
  end
end
