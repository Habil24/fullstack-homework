# Here we simulate a database connection with Fields
class FieldsService
  include Singleton

  def fetch_fields
    [
      {
        id: 1,
        name: 'Mäeotsa',
        area: 0.93,
        crops: [
          { year: 2020, crop: CropsService::WINTER_WHEAT },
          { year: 2021, crop: CropsService::OATS },
          { year: 2022, crop: CropsService::WINTER_WHEAT },
          { year: 2023, crop: CropsService::OATS },
          { year: 2024, crop: CropsService::WINTER_WHEAT },
        ],
      },
      {
        id: 2,
        name: 'Tiigimanu',
        area: 3.14,
        crops: [
          { year: 2020, crop: CropsService::SPRING_WHEAT },
          { year: 2021, crop: CropsService::OATS },
          { year: 2022, crop: CropsService::RED_CLOVER },
          { year: 2023, crop: CropsService::WINTER_WHEAT },
          { year: 2024, crop: CropsService::BROAD_BEAN },
        ],
      },
      {
        id: 3,
        name: 'Künkatagune',
        area: 5.18,
        crops: [
          { year: 2020, crop: CropsService::SPRING_WHEAT },
          { year: 2021, crop: CropsService::SPRING_WHEAT },
          { year: 2022, crop: CropsService::SPRING_WHEAT },
          { year: 2023, crop: CropsService::SPRING_WHEAT },
          { year: 2024, crop: CropsService::SPRING_WHEAT },
        ],
      },
    ].map { |field| calculate_field_humus_balance(field) }
  end

  def calculate_field_humus_balance(field)
    total_humus_balance = 0
    crop_arr_length = field[:crops].length()

    field[:crops].each { |crop_obj| 
      total_humus_balance += CropsService.instance.crop_humus_delta_val(crop_obj[:crop][:value])
      current_crop_idx = field[:crops].find_index{|crop| crop[:year] == crop_obj[:year]}
      previous_crop_idx = current_crop_idx - 1

      shouldMultiply = check_if_valid_idx(previous_crop_idx,crop_arr_length) && isSameCrop(field[:crops],current_crop_idx,previous_crop_idx)
      if (shouldMultiply)
        total_humus_balance = total_humus_balance * 1.3
      end
    } 
    field[:humus_balance] = total_humus_balance.round(3) 
    return field
  end

  def updated_humus_balance(fieldId,cropVal,cropYear)
    newCrop = CropsService.instance.get_crop(Integer(cropVal))
    updatedField = update_field_crop(Integer(fieldId),newCrop,Integer(cropYear))
    newHumusBalance = calculate_field_humus_balance(updatedField)[:humus_balance]
    return newHumusBalance
    # In Real implementation we should save to DB too
  end

  def update_field_crop(fieldId,newCrop,cropYear)
    field = fetch_fields.find { |field| field[:id] == Integer(fieldId) }
    mutatedCropIdx = field[:crops].find_index{|crop| crop[:year] == Integer(cropYear)}
    field[:crops][mutatedCropIdx][:crop] = newCrop
    return field
  end

  def check_if_valid_idx(index,arrLength)
    return index >= 0 && index < arrLength
  end

  def isSameCrop(cropArr,currentCrop,previousCrop)
    return cropArr[currentCrop][:crop][:value] == cropArr[previousCrop][:crop][:value]
  end
end
