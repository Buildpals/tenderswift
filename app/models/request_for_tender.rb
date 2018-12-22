# frozen_string_literal: true

class RequestForTender < ApplicationRecord
  TENDERSWIFT_CUT = 0.10

  enum withdrawal_frequency: { 'Monthly' => 0,
                               'Every two weeks' => 1,
                               'Weekly' => 2 }

  enum access: {open_tendering: 0,
                closed_tendering: 1}

  serialize :contract_sum_address, Hash

  monetize :selling_price_subunit,
           as: :selling_price,
           with_model_currency: :tender_currency

  belongs_to :publisher, inverse_of: :request_for_tenders

  has_many :project_documents,
           dependent: :destroy,
           inverse_of: :request_for_tender
  accepts_nested_attributes_for :project_documents,
                                allow_destroy: true,
                                reject_if: :all_blank

  has_many :required_documents,
           dependent: :destroy,
           inverse_of: :request_for_tender
  accepts_nested_attributes_for :required_documents,
                                allow_destroy: true,
                                reject_if: :all_blank

  has_many :participants,
           dependent: :destroy,
           inverse_of: :request_for_tender
  accepts_nested_attributes_for :participants,
                                allow_destroy: true,
                                reject_if: :all_blank

  has_many :tenders,
           dependent: :destroy,
           inverse_of: :request_for_tender

  has_many :contractors, -> { distinct }, through: :tenders

  has_one :excel_file,
          dependent: :destroy,
          inverse_of: :request_for_tender

  delegate :name,
           :company_name,
           :company_logo,
           :phone_number,
           :email,
           to: :publisher,
           prefix: :project_owners

  scope :submitted, -> { where.not(submitted_at: nil).order(submitted_at: :desc) }
  scope :not_submitted, -> { where(submitted_at: nil).order(submitted_at: :desc) }

  scope :published, -> { where.not(published_at: nil).order(published_at: :desc) }

  scope :not_published, -> { where(published_at: nil).order(published_at: :desc) }
  scope :deadline_not_passed, -> {
    where("deadline > '#{Time.current}'").order(id: :desc)
  }

  scope :submitted_tenders, -> { tenders.where(submitted: true) }

  validate :version_number_is_greater_or_same, if: :list_of_rates?

  def version_number_is_greater_or_same
    previous_version_number = version_number_was
    if version_number < previous_version_number
      errors.add(:version_number, 'is less than previous version number')
    end
  end

  validates :project_name, presence: true, if: :active?
  #validates :city, :country_code, presence: true, if: :not_sample?

  validate :check_deadline

  validates :project_name,
            :deadline,
            :description,
            presence: true,
            if: :active_or_general_information?

  # validates :list_of_items, presence: true, if: :active_or_bill_of_quantities?
  # validates :tender_documents, presence: true, if: :active_or_tender_documents?
  # validates :tender_instructions, presence: true, if: :active_or_tender_instructions?
  validates :selling_price, presence: true, if: :active_or_distribution?

  def to_param
    "#{id}-#{project_name.parameterize}"
  end

  def name
    "##{id} #{project_name}"
  end

  def submitted?
    submitted_at.present?
  end

  def published?
    published_at.present?
  end

  def list_of_rates?
    list_of_rates.present?
  end

  def deadline_over?
    Time.current > deadline
  end

  def payment_gateway_charge
    selling_price * 0.035
  end

  def cloud_service_charge
    selling_price * 0.065
  end

  def amount_to_be_deducted
    selling_price + (RequestForTender::TENDERSWIFT_CUT * selling_price)
  end

  def number_of_tender_purchases
    tenders.where.not(purchased_at: nil).size
  end

  def total_receivable
    number_of_tender_purchases * selling_price
  end

  def setup_with_data(location)
    #byebug
    self.project_name = 'Untitled Project #' \
                        "#{publisher.request_for_tenders.count + 1}"
    self.country_code = location.country_code
    self.city = location.city
    self.deadline = Time.current + 1.month
    required_documents.build(title: 'Certificate of Incorporation')
    required_documents.build(title: 'Certificate of Commencement')
    required_documents.build(title: 'Financial statements (3 years )')
    save!
  end

  def setup_sample_request_for_tender(location)
    self.project_name = 'Sample Request For Tender'
    self.country_code = location.country_code
    self.city = location.city
    self.deadline = Time.current + 1.month
    self.description = 'The structure is a one-storey skeleton frames facility with solid sandcrete block walls as partitions. It covers an area of 478sqm'
    self.tender_currency = 'USD'
    self.selling_price_subunit = 10000
    self.bank_name = 'International Bank'
    self.account_name = 'Sample Construction Services'
    self.account_number = '123456789123456'
    self.withdrawal_frequency = 1
    self.tender_figure_address = 'Sheet4!F4'
    self.tender_instructions = 'Provide the required documents listed above'
    self.sample = true
    project_document = ProjectDocument.new(document: 'https://res.cloudinary.com/tenderswift/raw/upload/v1513201013/project_documents/contract_documents_qlxqzt.docx', original_file_name: 'Sample document')
    self.project_documents << project_document
    self.list_of_items = {
        "Sheets": {
            "Sheet1": {
                "A1": {
                    "h": "Item",
                    "r": "<t>Item</t>",
                    "t": "s",
                    "v": "Item",
                    "w": "Item"
                },
                "A8": {
                    "h": "A",
                    "r": "<t>A</t>",
                    "t": "s",
                    "v": "A",
                    "w": "A"
                },
                "B1": {
                    "h": "Description",
                    "r": "<t>Description</t>",
                    "t": "s",
                    "v": "Description",
                    "w": "Description"
                },
                "B2": {
                    "h": "BILL No. 2 - GROUND FLOOR",
                    "r": "<t>BILL No. 2 - GROUND FLOOR</t>",
                    "t": "s",
                    "v": "BILL No. 2 - GROUND FLOOR",
                    "w": "BILL No. 2 - GROUND FLOOR"
                },
                "B4": {
                    "h": "SUBSTRUCTURE",
                    "r": "<t>SUBSTRUCTURE</t>",
                    "t": "s",
                    "v": "SUBSTRUCTURE",
                    "w": "SUBSTRUCTURE"
                },
                "B5": {
                    "h": "(ALL PROVISIONAL)",
                    "r": "<t>(ALL PROVISIONAL)</t>",
                    "t": "s",
                    "v": "(ALL PROVISIONAL)",
                    "w": "(ALL PROVISIONAL)"
                },
                "B6": {
                    "h": "Excavation and Earthwork",
                    "r": "<t>Excavation and Earthwork</t>",
                    "t": "s",
                    "v": "Excavation and Earthwork",
                    "w": "Excavation and Earthwork"
                },
                "B8": {
                    "h": "Excavate oversite to remove vegetable soil  average 150mm deep, load, deposit and level",
                    "r": "<t>Excavate oversite to remove vegetable soil  average 150mm deep, load, deposit and level</t>",
                    "t": "s",
                    "v": "Excavate oversite to remove vegetable soil  average 150mm deep, load, deposit and level",
                    "w": "Excavate oversite to remove vegetable soil  average 150mm deep, load, deposit and level"
                },
                "C1": {
                    "h": "Q&apos;ty",
                    "r": "<t>Q'ty</t>",
                    "t": "s",
                    "v": "Q'ty",
                    "w": "Q'ty"
                },
                "C8": {
                    "t": "n",
                    "v": 1200,
                    "w": "1200"
                },
                "D1": {
                    "h": "Unit",
                    "r": "<t>Unit</t>",
                    "t": "s",
                    "v": "Unit",
                    "w": "Unit"
                },
                "D8": {
                    "h": "cm",
                    "r": "<t>cm</t>",
                    "t": "s",
                    "v": "cm",
                    "w": "cm"
                },
                "E1": {
                    "h": "Rate",
                    "r": "<t>Rate</t>",
                    "t": "s",
                    "v": "Rate",
                    "w": " Rate "
                },
                "E8": {
                    "t": "n",
                    "v": 2.4,
                    "w": " 2.40 "
                },
                "F1": {
                    "h": "Amount (GH¢)",
                    "r": "<t>Amount (GH¢)</t>",
                    "t": "s",
                    "v": "Amount (GH¢)",
                    "w": " Amount (GH¢) "
                },
                "F8": {
                    "f": "C8*E8",
                    "t": "n",
                    "v": 2880,
                    "w": " 2,880.00 "
                },
                "A11": {
                    "h": "B",
                    "r": "<t>B</t>",
                    "t": "s",
                    "v": "B",
                    "w": "B"
                },
                "A14": {
                    "h": "C",
                    "r": "<t>C</t>",
                    "t": "s",
                    "v": "C",
                    "w": "C"
                },
                "A17": {
                    "h": "D",
                    "r": "<t>D</t>",
                    "t": "s",
                    "v": "D",
                    "w": "D"
                },
                "A20": {
                    "h": "E",
                    "r": "<t>E</t>",
                    "t": "s",
                    "v": "E",
                    "w": "E"
                },
                "A22": {
                    "h": "F",
                    "r": "<t>F</t>",
                    "t": "s",
                    "v": "F",
                    "w": "F"
                },
                "A26": {
                    "h": "G",
                    "r": "<t>G</t>",
                    "t": "s",
                    "v": "G",
                    "w": "G"
                },
                "A31": {
                    "h": "H",
                    "r": "<t>H</t>",
                    "t": "s",
                    "v": "H",
                    "w": "H"
                },
                "A35": {
                    "h": "J",
                    "r": "<t>J</t>",
                    "t": "s",
                    "v": "J",
                    "w": "J"
                },
                "A37": {
                    "h": "K",
                    "r": "<t>K</t>",
                    "t": "s",
                    "v": "K",
                    "w": "K"
                },
                "A41": {
                    "h": "L",
                    "r": "<t>L</t>",
                    "t": "s",
                    "v": "L",
                    "w": "L"
                },
                "A43": {
                    "h": "M",
                    "r": "<t>M</t>",
                    "t": "s",
                    "v": "M",
                    "w": "M"
                },
                "A50": {
                    "h": "A",
                    "r": "<t>A</t>",
                    "t": "s",
                    "v": "A",
                    "w": "A"
                },
                "A52": {
                    "h": "B",
                    "r": "<t>B</t>",
                    "t": "s",
                    "v": "B",
                    "w": "B"
                },
                "A57": {
                    "h": "C",
                    "r": "<t>C</t>",
                    "t": "s",
                    "v": "C",
                    "w": "C"
                },
                "A59": {
                    "h": "D",
                    "r": "<t>D</t>",
                    "t": "s",
                    "v": "D",
                    "w": "D"
                },
                "A61": {
                    "h": "E",
                    "r": "<t>E</t>",
                    "t": "s",
                    "v": "E",
                    "w": "E"
                },
                "A63": {
                    "h": "F",
                    "r": "<t>F</t>",
                    "t": "s",
                    "v": "F",
                    "w": "F"
                },
                "A66": {
                    "h": "G",
                    "r": "<t>G</t>",
                    "t": "s",
                    "v": "G",
                    "w": "G"
                },
                "A70": {
                    "h": "H",
                    "r": "<t>H</t>",
                    "t": "s",
                    "v": "H",
                    "w": "H"
                },
                "A72": {
                    "h": "J",
                    "r": "<t>J</t>",
                    "t": "s",
                    "v": "J",
                    "w": "J"
                },
                "A74": {
                    "h": "K",
                    "r": "<t>K</t>",
                    "t": "s",
                    "v": "K",
                    "w": "K"
                },
                "A76": {
                    "h": "L",
                    "r": "<t>L</t>",
                    "t": "s",
                    "v": "L",
                    "w": "L"
                },
                "A78": {
                    "h": "M",
                    "r": "<t>M</t>",
                    "t": "s",
                    "v": "M",
                    "w": "M"
                },
                "A80": {
                    "h": "N",
                    "r": "<t>N</t>",
                    "t": "s",
                    "v": "N",
                    "w": "N"
                },
                "A86": {
                    "h": "P",
                    "r": "<t>P</t>",
                    "t": "s",
                    "v": "P",
                    "w": "P"
                },
                "B11": {
                    "h": "Excavate pits to receive column bases average depth not exceeding 1.5m from formation level",
                    "r": "<t>Excavate pits to receive column bases average depth not exceeding 1.5m from formation level</t>",
                    "t": "s",
                    "v": "Excavate pits to receive column bases average depth not exceeding 1.5m from formation level",
                    "w": "Excavate pits to receive column bases average depth not exceeding 1.5m from formation level"
                },
                "B14": {
                    "h": "Excavate trenches to receive strip foundations average depth not exceeding 1.5m ditto",
                    "r": "<t>Excavate trenches to receive strip foundations average depth not exceeding 1.5m ditto</t>",
                    "t": "s",
                    "v": "Excavate trenches to receive strip foundations average depth not exceeding 1.5m ditto",
                    "w": "Excavate trenches to receive strip foundations average depth not exceeding 1.5m ditto"
                },
                "B17": {
                    "h": "Extra over normal excavation for excavating through rock or hardpan laterite (Provisional)",
                    "r": "<t>Extra over normal excavation for excavating through rock or hardpan laterite (Provisional)</t>",
                    "t": "s",
                    "v": "Extra over normal excavation for excavating through rock or hardpan laterite (Provisional)",
                    "w": "Extra over normal excavation for excavating through rock or hardpan laterite (Provisional)"
                },
                "B20": {
                    "h": "Backfil around foundations with selected excavated material well rammed in layers",
                    "r": "<t>Backfil around foundations with selected excavated material well rammed in layers</t>",
                    "t": "s",
                    "v": "Backfil around foundations with selected excavated material well rammed in layers",
                    "w": "Backfil around foundations with selected excavated material well rammed in layers"
                },
                "B22": {
                    "h": "Remove surplus excavated material from site",
                    "r": "<t>Remove surplus excavated material from site</t>",
                    "t": "s",
                    "v": "Remove surplus excavated material from site",
                    "w": "Remove surplus excavated material from site"
                },
                "B24": {
                    "h": "Hardcore filling",
                    "r": "<t>Hardcore filling</t>",
                    "t": "s",
                    "v": "Hardcore filling",
                    "w": "Hardcore filling"
                },
                "B26": {
                    "h": "Approved hardcore filling to make up levels under bed, rammed and consolidated in 225mm layers",
                    "r": "<t>Approved hardcore filling to make up levels under bed, rammed and consolidated in 225mm layers</t>",
                    "t": "s",
                    "v": "Approved hardcore filling to make up levels under bed, rammed and consolidated in 225mm layers",
                    "w": "Approved hardcore filling to make up levels under bed, rammed and consolidated in 225mm layers"
                },
                "B28": {
                    "h": "Concrete Work",
                    "r": "<t>Concrete Work</t>",
                    "t": "s",
                    "v": "Concrete Work",
                    "w": "Concrete Work"
                },
                "B29": {
                    "h": "Plain insitu concrete (1 : 4 : 8 - 38mm Aggregate) as described in:",
                    "r": "<t>Plain insitu concrete (1 : 4 : 8 - 38mm Aggregate) as described in:</t>",
                    "t": "s",
                    "v": "Plain insitu concrete (1 : 4 : 8 - 38mm Aggregate) as described in:",
                    "w": "Plain insitu concrete (1 : 4 : 8 - 38mm Aggregate) as described in:"
                },
                "B31": {
                    "h": "50mm blinding bed",
                    "r": "<t>50mm blinding bed</t>",
                    "t": "s",
                    "v": "50mm blinding bed",
                    "w": "50mm blinding bed"
                },
                "B33": {
                    "h": "Plain insitu concrete (1 : 3 : 6 - 20mm Aggregate) as described in:",
                    "r": "<t>Plain insitu concrete (1 : 3 : 6 - 20mm Aggregate) as described in:</t>",
                    "t": "s",
                    "v": "Plain insitu concrete (1 : 3 : 6 - 20mm Aggregate) as described in:",
                    "w": "Plain insitu concrete (1 : 3 : 6 - 20mm Aggregate) as described in:"
                },
                "B35": {
                    "h": "Strip foundations",
                    "r": "<t>Strip foundations</t>",
                    "t": "s",
                    "v": "Strip foundations",
                    "w": "Strip foundations"
                },
                "B37": {
                    "h": "Steps ",
                    "r": "<t xml:space=\"preserve\">Steps </t>",
                    "t": "s",
                    "v": "Steps ",
                    "w": "Steps "
                },
                "B39": {
                    "h": "Reinforced insitu concrete (1 : 2 : 4 - 19mm  Aggregate) as described in:",
                    "r": "<t>Reinforced insitu concrete (1 : 2 : 4 - 19mm  Aggregate) as described in:</t>",
                    "t": "s",
                    "v": "Reinforced insitu concrete (1 : 2 : 4 - 19mm  Aggregate) as described in:",
                    "w": "Reinforced insitu concrete (1 : 2 : 4 - 19mm  Aggregate) as described in:"
                },
                "B41": {
                    "h": "Column bases",
                    "r": "<t>Column bases</t>",
                    "t": "s",
                    "v": "Column bases",
                    "w": "Column bases"
                },
                "B43": {
                    "h": "Columns",
                    "r": "<t>Columns</t>",
                    "t": "s",
                    "v": "Columns",
                    "w": "Columns"
                },
                "B48": {
                    "h": "Reinforced insitu concrete (1 : 2 : 4 - 19mm Aggregate) as described in:",
                    "r": "<t>Reinforced insitu concrete (1 : 2 : 4 - 19mm Aggregate) as described in:</t>",
                    "t": "s",
                    "v": "Reinforced insitu concrete (1 : 2 : 4 - 19mm Aggregate) as described in:",
                    "w": "Reinforced insitu concrete (1 : 2 : 4 - 19mm Aggregate) as described in:"
                },
                "B50": {
                    "h": "Ground beams",
                    "r": "<t>Ground beams</t>",
                    "t": "s",
                    "v": "Ground beams",
                    "w": "Ground beams"
                },
                "B52": {
                    "h": "150mm bed",
                    "r": "<t>150mm bed</t>",
                    "t": "s",
                    "v": "150mm bed",
                    "w": "150mm bed"
                },
                "B54": {
                    "h": "Reinforcement",
                    "r": "<t>Reinforcement</t>",
                    "t": "s",
                    "v": "Reinforcement",
                    "w": "Reinforcement"
                },
                "B55": {
                    "h": "Mild Steel round bar reinforcement to BS4449 cut, bent and fixed into position as described in:",
                    "r": "<t>Mild Steel round bar reinforcement to BS4449 cut, bent and fixed into position as described in:</t>",
                    "t": "s",
                    "v": "Mild Steel round bar reinforcement to BS4449 cut, bent and fixed into position as described in:",
                    "w": "Mild Steel round bar reinforcement to BS4449 cut, bent and fixed into position as described in:"
                },
                "B57": {
                    "h": "20mm Diameter bars in column bases",
                    "r": "<t>20mm Diameter bars in column bases</t>",
                    "t": "s",
                    "v": "20mm Diameter bars in column bases",
                    "w": "20mm Diameter bars in column bases"
                },
                "B59": {
                    "h": "20mm Diameter bars in columns",
                    "r": "<t>20mm Diameter bars in columns</t>",
                    "t": "s",
                    "v": "20mm Diameter bars in columns",
                    "w": "20mm Diameter bars in columns"
                },
                "B61": {
                    "h": "12mm diameter bars in ground beam",
                    "r": "<t>12mm diameter bars in ground beam</t>",
                    "t": "s",
                    "v": "12mm diameter bars in ground beam",
                    "w": "12mm diameter bars in ground beam"
                },
                "B63": {
                    "h": "10mm diameter bars in links and stirrups",
                    "r": "<t>10mm diameter bars in links and stirrups</t>",
                    "t": "s",
                    "v": "10mm diameter bars in links and stirrups",
                    "w": "10mm diameter bars in links and stirrups"
                },
                "B66": {
                    "h": "A142 mesh reinforcement in floor bed, laid with 300mm laps",
                    "r": "<t>A142 mesh reinforcement in floor bed, laid with 300mm laps</t>",
                    "t": "s",
                    "v": "A142 mesh reinforcement in floor bed, laid with 300mm laps",
                    "w": "A142 mesh reinforcement in floor bed, laid with 300mm laps"
                },
                "B68": {
                    "h": "Formwork",
                    "r": "<t>Formwork</t>",
                    "t": "s",
                    "v": "Formwork",
                    "w": "Formwork"
                },
                "B69": {
                    "h": "Sawn formwork to:",
                    "r": "<t>Sawn formwork to:</t>",
                    "t": "s",
                    "v": "Sawn formwork to:",
                    "w": "Sawn formwork to:"
                },
                "B70": {
                    "h": "Vertical sides of column bases",
                    "r": "<t>Vertical sides of column bases</t>",
                    "t": "s",
                    "v": "Vertical sides of column bases",
                    "w": "Vertical sides of column bases"
                },
                "B72": {
                    "h": "Vertical sides of columns",
                    "r": "<t>Vertical sides of columns</t>",
                    "t": "s",
                    "v": "Vertical sides of columns",
                    "w": "Vertical sides of columns"
                },
                "B74": {
                    "h": "Vertical sides of Steps",
                    "r": "<t>Vertical sides of Steps</t>",
                    "t": "s",
                    "v": "Vertical sides of Steps",
                    "w": "Vertical sides of Steps"
                },
                "B76": {
                    "h": "Sides of Ground Beams",
                    "r": "<t>Sides of Ground Beams</t>",
                    "t": "s",
                    "v": "Sides of Ground Beams",
                    "w": "Sides of Ground Beams"
                },
                "B78": {
                    "h": "Edges of 150mm thick bed",
                    "r": "<t>Edges of 150mm thick bed</t>",
                    "t": "s",
                    "v": "Edges of 150mm thick bed",
                    "w": "Edges of 150mm thick bed"
                },
                "B80": {
                    "h": "Risers of steps, 150mm wide",
                    "r": "<t>Risers of steps, 150mm wide</t>",
                    "t": "s",
                    "v": "Risers of steps, 150mm wide",
                    "w": "Risers of steps, 150mm wide"
                },
                "B82": {
                    "h": "Blockwork",
                    "r": "<t>Blockwork</t>",
                    "t": "s",
                    "v": "Blockwork",
                    "w": "Blockwork"
                },
                "B83": {
                    "h": "Solid sandcrete blockwork in cement and sand (1 : 4) mortar as described in:",
                    "r": "<t>Solid sandcrete blockwork in cement and sand (1 : 4) mortar as described in:</t>",
                    "t": "s",
                    "v": "Solid sandcrete blockwork in cement and sand (1 : 4) mortar as described in:",
                    "w": "Solid sandcrete blockwork in cement and sand (1 : 4) mortar as described in:"
                },
                "B86": {
                    "h": "150mm thick wall",
                    "r": "<t>150mm thick wall</t>",
                    "t": "s",
                    "v": "150mm thick wall",
                    "w": "150mm thick wall"
                },
                "B93": {
                    "h": "Carried to Summary",
                    "r": "<t>Carried to Summary</t>",
                    "t": "s",
                    "v": "Carried to Summary",
                    "w": "Carried to Summary"
                },
                "C11": {
                    "t": "n",
                    "v": 240,
                    "w": "240"
                },
                "C14": {
                    "t": "n",
                    "v": 166,
                    "w": "166"
                },
                "C17": {
                    "t": "n",
                    "v": 5,
                    "w": "5"
                },
                "C20": {
                    "t": "n",
                    "v": 310,
                    "w": "310"
                },
                "C22": {
                    "t": "n",
                    "v": 96,
                    "w": "96"
                },
                "C26": {
                    "t": "n",
                    "v": 300,
                    "w": "300"
                },
                "C31": {
                    "t": "n",
                    "v": 150,
                    "w": "150"
                },
                "C35": {
                    "t": "n",
                    "v": 31,
                    "w": "31"
                },
                "C37": {
                    "t": "n",
                    "v": 2,
                    "w": "2"
                },
                "C41": {
                    "t": "n",
                    "v": 84,
                    "w": "84"
                },
                "C43": {
                    "t": "n",
                    "v": 27,
                    "w": "27"
                },
                "C50": {
                    "t": "n",
                    "v": 18,
                    "w": "18"
                },
                "C52": {
                    "t": "n",
                    "v": 630,
                    "w": "630"
                },
                "C57": {
                    "t": "n",
                    "v": 2640,
                    "w": "2640"
                },
                "C59": {
                    "t": "n",
                    "v": 1693,
                    "w": "1693"
                },
                "C61": {
                    "t": "n",
                    "v": 1128,
                    "w": "1128"
                },
                "C63": {
                    "t": "n",
                    "v": 1086,
                    "w": "1086"
                },
                "C66": {
                    "t": "n",
                    "v": 630,
                    "w": "630"
                },
                "C70": {
                    "t": "n",
                    "v": 222,
                    "w": "222"
                },
                "C72": {
                    "t": "n",
                    "v": 101,
                    "w": "101"
                },
                "C74": {
                    "t": "n",
                    "v": 2,
                    "w": "2"
                },
                "C76": {
                    "t": "n",
                    "v": 123,
                    "w": "123"
                },
                "C78": {
                    "t": "n",
                    "v": 239,
                    "w": "239"
                },
                "C80": {
                    "t": "n",
                    "v": 17,
                    "w": "17"
                },
                "C86": {
                    "t": "n",
                    "v": 424,
                    "w": "424"
                },
                "D11": {
                    "h": "cm",
                    "r": "<t>cm</t>",
                    "t": "s",
                    "v": "cm",
                    "w": "cm"
                },
                "D14": {
                    "h": "cm",
                    "r": "<t>cm</t>",
                    "t": "s",
                    "v": "cm",
                    "w": "cm"
                },
                "D17": {
                    "h": "cm",
                    "r": "<t>cm</t>",
                    "t": "s",
                    "v": "cm",
                    "w": "cm"
                },
                "D20": {
                    "h": "cm",
                    "r": "<t>cm</t>",
                    "t": "s",
                    "v": "cm",
                    "w": "cm"
                },
                "D22": {
                    "h": "cm",
                    "r": "<t>cm</t>",
                    "t": "s",
                    "v": "cm",
                    "w": "cm"
                },
                "D26": {
                    "h": "cm",
                    "r": "<t>cm</t>",
                    "t": "s",
                    "v": "cm",
                    "w": "cm"
                },
                "D31": {
                    "h": "sm",
                    "r": "<t>sm</t>",
                    "t": "s",
                    "v": "sm",
                    "w": "sm"
                },
                "D35": {
                    "h": "cm",
                    "r": "<t>cm</t>",
                    "t": "s",
                    "v": "cm",
                    "w": "cm"
                },
                "D37": {
                    "h": "cm",
                    "r": "<t>cm</t>",
                    "t": "s",
                    "v": "cm",
                    "w": "cm"
                },
                "D41": {
                    "h": "cm",
                    "r": "<t>cm</t>",
                    "t": "s",
                    "v": "cm",
                    "w": "cm"
                },
                "D43": {
                    "h": "cm",
                    "r": "<t>cm</t>",
                    "t": "s",
                    "v": "cm",
                    "w": "cm"
                },
                "D50": {
                    "h": "cm",
                    "r": "<t>cm</t>",
                    "t": "s",
                    "v": "cm",
                    "w": "cm"
                },
                "D52": {
                    "h": "sm",
                    "r": "<t>sm</t>",
                    "t": "s",
                    "v": "sm",
                    "w": "sm"
                },
                "D57": {
                    "h": "kg",
                    "r": "<t>kg</t>",
                    "t": "s",
                    "v": "kg",
                    "w": "kg"
                },
                "D59": {
                    "h": "kg",
                    "r": "<t>kg</t>",
                    "t": "s",
                    "v": "kg",
                    "w": "kg"
                },
                "D61": {
                    "h": "kg",
                    "r": "<t>kg</t>",
                    "t": "s",
                    "v": "kg",
                    "w": "kg"
                },
                "D63": {
                    "h": "kg",
                    "r": "<t>kg</t>",
                    "t": "s",
                    "v": "kg",
                    "w": "kg"
                },
                "D66": {
                    "h": "sm",
                    "r": "<t>sm</t>",
                    "t": "s",
                    "v": "sm",
                    "w": "sm"
                },
                "D70": {
                    "h": "sm",
                    "r": "<t>sm</t>",
                    "t": "s",
                    "v": "sm",
                    "w": "sm"
                },
                "D72": {
                    "h": "sm",
                    "r": "<t>sm</t>",
                    "t": "s",
                    "v": "sm",
                    "w": "sm"
                },
                "D74": {
                    "h": "sm",
                    "r": "<t>sm</t>",
                    "t": "s",
                    "v": "sm",
                    "w": "sm"
                },
                "D76": {
                    "h": "sm",
                    "r": "<t>sm</t>",
                    "t": "s",
                    "v": "sm",
                    "w": "sm"
                },
                "D78": {
                    "h": "lm",
                    "r": "<t>lm</t>",
                    "t": "s",
                    "v": "lm",
                    "w": "lm"
                },
                "D80": {
                    "h": "lm",
                    "r": "<t>lm</t>",
                    "t": "s",
                    "v": "lm",
                    "w": "lm"
                },
                "D86": {
                    "h": "sm",
                    "r": "<t>sm</t>",
                    "t": "s",
                    "v": "sm",
                    "w": "sm"
                },
                "E11": {
                    "t": "n",
                    "v": 21,
                    "w": " 21.00 "
                },
                "E14": {
                    "t": "n",
                    "v": 17.5,
                    "w": " 17.50 "
                },
                "E17": {
                    "t": "n",
                    "v": 80,
                    "w": " 80.00 "
                },
                "E20": {
                    "t": "n",
                    "v": 15,
                    "w": " 15.00 "
                },
                "E22": {
                    "t": "n",
                    "v": 13,
                    "w": " 13.00 "
                },
                "E26": {
                    "t": "n",
                    "v": 65,
                    "w": " 65.00 "
                },
                "E31": {
                    "f": "E35*0.05",
                    "t": "n",
                    "v": 22.5,
                    "w": " 22.50 "
                },
                "E35": {
                    "t": "n",
                    "v": 450,
                    "w": " 450.00 "
                },
                "E37": {
                    "f": "E35",
                    "t": "n",
                    "v": 450,
                    "w": " 450.00 "
                },
                "E41": {
                    "t": "n",
                    "v": 520,
                    "w": " 520.00 "
                },
                "E43": {
                    "f": "E41",
                    "t": "n",
                    "v": 520,
                    "w": " 520.00 "
                },
                "E50": {
                    "f": "E41",
                    "t": "n",
                    "v": 520,
                    "w": " 520.00 "
                },
                "E52": {
                    "f": "E50*0.15",
                    "t": "n",
                    "v": 78,
                    "w": " 78.00 "
                },
                "E57": {
                    "t": "n",
                    "v": 3.5,
                    "w": " 3.50 "
                },
                "E59": {
                    "f": "E57",
                    "t": "n",
                    "v": 3.5,
                    "w": " 3.50 "
                },
                "E61": {
                    "f": "E57",
                    "t": "n",
                    "v": 3.5,
                    "w": " 3.50 "
                },
                "E63": {
                    "f": "E57",
                    "t": "n",
                    "v": 3.5,
                    "w": " 3.50 "
                },
                "E66": {
                    "t": "n",
                    "v": 9,
                    "w": " 9.00 "
                },
                "E70": {
                    "t": "n",
                    "v": 19,
                    "w": " 19.00 "
                },
                "E72": {
                    "f": "E70",
                    "t": "n",
                    "v": 19,
                    "w": " 19.00 "
                },
                "E74": {
                    "f": "E70",
                    "t": "n",
                    "v": 19,
                    "w": " 19.00 "
                },
                "E76": {
                    "f": "E70",
                    "t": "n",
                    "v": 19,
                    "w": " 19.00 "
                },
                "E78": {
                    "f": "E70*0.15",
                    "t": "n",
                    "v": 2.85,
                    "w": " 2.85 "
                },
                "E80": {
                    "f": "E78",
                    "t": "n",
                    "v": 2.85,
                    "w": " 2.85 "
                },
                "E86": {
                    "t": "n",
                    "v": 50,
                    "w": " 50.00 "
                },
                "F11": {
                    "f": "C11*E11",
                    "t": "n",
                    "v": 5040,
                    "w": " 5,040.00 "
                },
                "F14": {
                    "f": "C14*E14",
                    "t": "n",
                    "v": 2905,
                    "w": " 2,905.00 "
                },
                "F17": {
                    "f": "C17*E17",
                    "t": "n",
                    "v": 400,
                    "w": " 400.00 "
                },
                "F20": {
                    "f": "C20*E20",
                    "t": "n",
                    "v": 4650,
                    "w": " 4,650.00 "
                },
                "F22": {
                    "f": "C22*E22",
                    "t": "n",
                    "v": 1248,
                    "w": " 1,248.00 "
                },
                "F26": {
                    "f": "C26*E26",
                    "t": "n",
                    "v": 19500,
                    "w": " 19,500.00 "
                },
                "F31": {
                    "f": "C31*E31",
                    "t": "n",
                    "v": 3375,
                    "w": " 3,375.00 "
                },
                "F35": {
                    "f": "C35*E35",
                    "t": "n",
                    "v": 13950,
                    "w": " 13,950.00 "
                },
                "F37": {
                    "f": "C37*E37",
                    "t": "n",
                    "v": 900,
                    "w": " 900.00 "
                },
                "F41": {
                    "f": "C41*E41",
                    "t": "n",
                    "v": 43680,
                    "w": " 43,680.00 "
                },
                "F43": {
                    "f": "C43*E43",
                    "t": "n",
                    "v": 14040,
                    "w": " 14,040.00 "
                },
                "F50": {
                    "f": "C50*E50",
                    "t": "n",
                    "v": 9360,
                    "w": " 9,360.00 "
                },
                "F52": {
                    "f": "C52*E52",
                    "t": "n",
                    "v": 49140,
                    "w": " 49,140.00 "
                },
                "F57": {
                    "f": "C57*E57",
                    "t": "n",
                    "v": 9240,
                    "w": " 9,240.00 "
                },
                "F59": {
                    "f": "C59*E59",
                    "t": "n",
                    "v": 5925.5,
                    "w": " 5,925.50 "
                },
                "F61": {
                    "f": "C61*E61",
                    "t": "n",
                    "v": 3948,
                    "w": " 3,948.00 "
                },
                "F63": {
                    "f": "C63*E63",
                    "t": "n",
                    "v": 3801,
                    "w": " 3,801.00 "
                },
                "F66": {
                    "f": "C66*E66",
                    "t": "n",
                    "v": 5670,
                    "w": " 5,670.00 "
                },
                "F70": {
                    "f": "C70*E70",
                    "t": "n",
                    "v": 4218,
                    "w": " 4,218.00 "
                },
                "F72": {
                    "f": "C72*E72",
                    "t": "n",
                    "v": 1919,
                    "w": " 1,919.00 "
                },
                "F74": {
                    "f": "C74*E74",
                    "t": "n",
                    "v": 38,
                    "w": " 38.00 "
                },
                "F76": {
                    "f": "C76*E76",
                    "t": "n",
                    "v": 2337,
                    "w": " 2,337.00 "
                },
                "F78": {
                    "f": "C78*E78",
                    "t": "n",
                    "v": 681.15,
                    "w": " 681.15 "
                },
                "F80": {
                    "f": "C80*E80",
                    "t": "n",
                    "v": 48.45,
                    "w": " 48.45 "
                },
                "F86": {
                    "f": "C86*E86",
                    "t": "n",
                    "v": 21200,
                    "w": " 21,200.00 "
                },
                "F93": {
                    "f": "SUM(F2:F90)",
                    "t": "n",
                    "v": 230094.1,
                    "w": " 230,094.10 "
                },
                "!ref": "A1:I1873",
                "!margins": {
                    "top": 0.5,
                    "left": 0.7,
                    "right": 0,
                    "bottom": 0,
                    "footer": 0.511805555555555,
                    "header": 0.511805555555555
                }
            },
            "Sheet4": {
                "A1": {
                    "h": "Item",
                    "r": "<t>Item</t>",
                    "t": "s",
                    "v": "Item",
                    "w": "Item"
                },
                "B1": {
                    "h": "Description",
                    "r": "<t>Description</t>",
                    "t": "s",
                    "v": "Description",
                    "w": "Description"
                },
                "B3": {
                    "h": "Summary",
                    "r": "<t>Summary</t>",
                    "t": "s",
                    "v": "Summary",
                    "w": "Summary"
                },
                "B4": {
                    "h": "Carried to Summary",
                    "r": "<t>Carried to Summary</t>",
                    "t": "s",
                    "v": "Carried to Summary",
                    "w": "Carried to Summary"
                },
                "C1": {
                    "h": "Q&apos;ty",
                    "r": "<t>Q'ty</t>",
                    "t": "s",
                    "v": "Q'ty",
                    "w": "Q'ty"
                },
                "D1": {
                    "h": "Unit",
                    "r": "<t>Unit</t>",
                    "t": "s",
                    "v": "Unit",
                    "w": "Unit"
                },
                "E1": {
                    "h": "Rate",
                    "r": "<t>Rate</t>",
                    "t": "s",
                    "v": "Rate",
                    "w": " Rate "
                },
                "F1": {
                    "h": "Amount (GH¢)",
                    "r": "<t>Amount (GH¢)</t>",
                    "t": "s",
                    "v": "Amount (GH¢)",
                    "w": " Amount (GH¢) "
                },
                "F3": {
                    "f": "SUM(Sheet1!F2:F90)",
                    "t": "n",
                    "v": 230094.1,
                    "w": " 230,094.10 "
                },
                "F4": {
                    "f": "Sheet1!F93",
                    "t": "n",
                    "v": 230094.1,
                    "w": " 230,094.10 "
                },
                "!ref": "A1:I1873",
                "!margins": {
                    "top": 0.75,
                    "left": 0.7,
                    "right": 0.7,
                    "bottom": 0.75,
                    "footer": 0.3,
                    "header": 0.3
                }
            }
        },
        "SheetNames": [
            "Sheet1",
            "Sheet4"
        ]
    }
    self.list_of_rates =
        {
            "Sheet1!E8": 2.4,
            "Sheet1!E11": 21,
            "Sheet1!E14": 17.5,
            "Sheet1!E17": 80,
            "Sheet1!E20": 15,
            "Sheet1!E22": 13,
            "Sheet1!E26": 65,
            "Sheet1!E35": 450,
            "Sheet1!E41": 520,
            "Sheet1!E57": 3.5,
            "Sheet1!E66": 9,
            "Sheet1!E70": 19,
            "Sheet1!E86": 50
        }
    required_documents.build(title: 'Certificate of Incorporation')
    required_documents.build(title: 'Financial statements (3 years )')
    save!
  end

  def workbook
    workbook = list_of_items_without_rates
    list_of_rates.each do |key, value|
      sheet_name = key.split('!')[0]
      row_col_ref = key.split('!')[1]
      workbook['Sheets'][sheet_name][row_col_ref]['v'] = value
    end
    workbook
  end

  def list_of_items_without_rates
    strip_qs_rates(list_of_items)
  end

  def get_list_of_rates(workbook)
    list_of_rates = {}
    workbook['SheetNames'].each do |sheetName|
      sheet = workbook['Sheets'][sheetName]
      sheet.keys
           .select { |cell_address| rate_cell?(cell_address, sheet) }
           .each do |cell_address|

        list_of_rates["#{sheetName}!#{cell_address}"] = sheet[cell_address]['v']
      end
    end
    list_of_rates
  end

  def tenders_with_mine
    value = tenders.submitted.as_json(only: %i[id list_of_rates],
                                      methods: [:contractors_company_name])
    my_tender = {
      id: 42,
      list_of_rates: list_of_rates,
      contractors_company_name: publisher.company_name
    }

    value.unshift(my_tender)
  end

  private

  def check_deadline
    return unless deadline

    if deadline < Date.today
      errors.add(:deadline, :invalid, message: 'Deadline cannot be in the past')
    end
  end

  def strip_qs_rates(workbook)
    workbook['Sheets'].each_value do |sheet|
      sheet.keys
           .select { |cell_address| rate_or_amount_cell?(cell_address, sheet) }
           .each do |cell_address|

        sheet[cell_address] = {
          'f' => sheet[cell_address]['f'],
          'v' => ''
        }

        sheet[cell_address]['c'] = 'allowEditing' if cell_address[0] == 'E'
      end
    end
    workbook
  end

  def rate_or_amount_cell?(cell_address, sheet)
    rate_cell?(cell_address, sheet) || amount_cell?(cell_address, sheet)
  end

  def rate_cell?(cell_address, sheet)
    return false if cell_address[0] != 'E'
    return false if sheet[cell_address]['f']

    sheet[cell_address]['v'].is_a?(Numeric)
  end

  def amount_cell?(cell_address, sheet)
    return false if cell_address[0] != 'F'

    sheet[cell_address]['v'].is_a?(Numeric)
  end

  def active?
    status == 'active'
  end

  def not_sample?
    sample == false
  end

  def active_or_general_information?
    status.include?(:general_information.to_s) || active?
  end

  def active_or_bill_of_quantities?
    status.include?(:bill_of_quantities.to_s) || active?
  end

  def active_or_tender_documents?
    status.include?(:tender_documents.to_s) || active?
  end

  def active_or_tender_instructions?
    status.include?(:tender_instructions.to_s) || active?
  end

  def active_or_distribution?
    status.include?(:distribution.to_s) || active?
  end
end
