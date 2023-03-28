Rails.application.routes.draw do
  devise_for :users
  root to: 'homes#home'
  get "top" => 'homes#top'
  get "setting" => 'homes#setting'
  get "policy" => 'homes#policy'
  get "info" => 'homes#info'
  get "home" => 'homes#home'
  get 'search' => 'homes#top'
  get "receive" => 'rules#receive'
  get "approval/:id" => 'rules#approval', as: "approval" #as:""でURLはapprovalを残しつつ、 同viewのeachメソッドで取得しているstandbyRules_id(standbyRuleとして取得している)も参照できるような記載の仕方
  get "denial/:id" => 'rules#denial', as: "denial"
  get "forgive/:id" => 'penalties#forgive', as:"forgive" #as:""でURLはforgiveを残しつつ、 同viewのeachメソッドで取得しているstandby_id(standbyPenaltiesとして取得している)も参照できるような記載の仕方
  get "forbid/:id" => 'penalties#forbid', as:"forbid"
  get "accept/:id" => "communities#accept", as:"accept"

  resources :users
  resources :communities do #URLがcommunityディレクトリ配下にrules、mottos、usersがくる
    get "detail" => 'communities#detail' #コミュニティの詳細説明への遷移
    resources :goals do
      get "achieved" => 'goals#achieved'
      get "unachieved" => 'goals#unachieved'
    end
    resources :meetings do
      get "pre_edit" => 'meetings#pre_edit'
    end
    resources :rules do
      get "execute" => 'rules#execute' #ルール実行画面への遷移
      post "execute" => 'rules#execute_create' #ルール実行申請。standbyテーブルにテーブルを新しく作成。
    end
    get "new_positive_rule" => 'rules#new_positive'
    get "new_negative_rule" => 'rules#new_negative'
    resources :mottos
    resources :privileges do
      get "execute" => 'privileges#execute' #今すぐ受けられる特典を「実行」したときのアクション
    end
    resources :penalties do
      get "execute" => 'penalties#execute'
      post "execute" => 'penalties#execute_create'
    end
    resources :users do
      get "mypage" => "users#mypage"
      get "editmemo" => "users#memo_edit"
      patch "updatememo" => "users#memo_update"
      get "erasememo" => "users#memo_erase"
      resources :roles
      resources :memo
    end
    resources :records, only: [:index, :show]
    get "join_request" => "communities#join_request"
    delete "out" => "communities#out"
  end

end
