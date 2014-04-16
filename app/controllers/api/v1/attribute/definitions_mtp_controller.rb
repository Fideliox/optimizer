class Api::V1::Attribute::DefinitionsMtpController < Api::ApplicationController
  def get_top_25()
    list1 = Eo::AttributeDefinitionsMtp.where("\"Attribute\" like 'Leg_TEU_Cap%'").limit(25).order("\"OppValuePerUnitOrValue\" desc")
    list2 = Eo::AttributeDefinitionsMtp.where("\"Attribute\" like 'Reefer_Cap%'").limit(25).order("\"OppValuePerUnitOrValue\" desc")
    list3 = Eo::ConversionResourceActivityMtp.all.limit(25).order("\"OppValuePerSTHour\" desc")
    items = []
    list1.each{|l|
      items << {
          Attribute: l.Attribute,
          Source: 'Total TEU Cap.',
          ObjectName: l.ObjectName,
          Facility: l.Facility,
          MaxUnitsOrValue: l.MaxUnitsOrValue,
          SolutionUnitsOrValue: l.SolutionUnitsOrValue,
          OppValuePerUnitOrValue: l.OppValuePerUnitOrValue
      }
    }
    list2.each{|l|
      items << {
          Attribute: l.Attribute,
          Source: 'Reefer Cap.',
          ObjectName: l.ObjectName,
          Facility: l.Facility,
          MaxUnitsOrValue: l.MaxUnitsOrValue,
          SolutionUnitsOrValue: l.SolutionUnitsOrValue,
          OppValuePerUnitOrValue: l.OppValuePerUnitOrValue
      }
    }
    list3.each{|l|
      items << {
          Attribute: l.Attribute1,
          Source: 'Weight Port Cap.',
          ObjectName: '',
          Facility: l.Facility,
          MaxUnitsOrValue: l.MaxSTHours,
          SolutionUnitsOrValue: l.SolutionSTHours,
          OppValuePerUnitOrValue: l.OppValuePerSTHour
      }
    }
    render json: items
  end

end