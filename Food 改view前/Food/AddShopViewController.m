//
//  AddShopViewController.m
//  Food
//
//  Created by Shiang-Yu Huang on 2016/10/15.
//  Copyright © 2016年 Shiang-Yu Huang. All rights reserved.
//
#import <Photos/Photos.h>
#import "AddShopViewController.h"
#import "FoodItemTableViewCell.h"







@interface AddShopViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{
    
    NSDictionary * shopInfo;
    
    NSDictionary * foodItem;
    
    NSMutableArray * foodItems;
    
    //判斷圖片放哪
    NSUInteger photoSavePlace;   // 1 = shop , 2 = foodItem
}
@property (weak, nonatomic) IBOutlet UITableView *fooditemsTableView;

//店家資訊
@property (weak, nonatomic) IBOutlet UITextField *shopNameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UITextField *shopAddressTextField;

@property (weak, nonatomic) IBOutlet UITextField *shopPhoneTextField;

//單筆菜單
@property (weak, nonatomic) IBOutlet UITextField *shopFoodItemTextField;

@property (weak, nonatomic) IBOutlet UITextField *foodItemPriceTextField;

@property (weak, nonatomic) IBOutlet UIImageView *shopFoodIconView;




@end

@implementation AddShopViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    foodItems = [NSMutableArray new];
    shopInfo =[NSMutableArray new];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)addFoodItemBtn:(id)sender {
    
    if ([_shopFoodItemTextField.text isEqualToString:@""] ||[_foodItemPriceTextField.text isEqualToString:@""]) {
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"餐點資訊尚未設置" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * ok = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:true completion:nil];
        
    }
    
    //沒給照片就給預設
    if (self.shopFoodIconView.image == nil) {
        self.shopFoodIconView.image = [UIImage imageNamed:@"unknow.png"];
    }
    
     NSData *foodImageData = UIImageJPEGRepresentation(self.shopFoodIconView.image, 0.5);
    
    
    
    NSDictionary * TmpFoodItem = @{DICT_FOOD_NAME_KEY:_shopFoodItemTextField.text,
                                   DICT_FOOD_PRICE_KEY:_foodItemPriceTextField.text,
                                   DICT_FOOD_IMAGE_KEY:foodImageData};
    
    [foodItems addObject:TmpFoodItem];
    
    
    //清空使用者輸入資料
    _shopFoodItemTextField.text = @"";
    _foodItemPriceTextField.text= @"";
    self.shopFoodIconView.image = [UIImage imageNamed:@"unknow.png"];
    
    [self.fooditemsTableView reloadData];
    
    
}


- (IBAction)okBtn:(id)sender {
    
    //--------------------------店家資訊------------------------------------
 
    NSString * shopName = self.shopNameTextField.text;
    NSString * shopAddress = self.shopAddressTextField.text;
    NSString * shopPhone = self.shopPhoneTextField.text;
    
    
    if ([shopName isEqualToString:@""] || [shopAddress isEqualToString:@""] || [shopPhone isEqualToString:@""]) {
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"店家資料未設置完全" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * ok = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:true completion:nil];
        
    }
    
    NSDictionary * shopInfo = @{DICT_SHOP_NAME_KEY:shopName,
                                DICT_SHOP_ADDRESS_KEY:shopAddress,
                                DICT_SHOP_PHONE_KEY:shopPhone};
    
    
    //--------------------------餐點品項------------------------------------
    
    
    
    
    
    
    
    
}

- (IBAction)cancelBtn:(id)sender {
    
    [self dismissViewControllerAnimated:true completion:nil];
    
}



#pragma mark - tableView delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return foodItems.count;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FoodItemTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSDictionary * each = foodItems[indexPath.row];
    
    cell.foodName.text = each[DICT_FOOD_NAME_KEY];
    cell.foodPrice.text = each[DICT_FOOD_PRICE_KEY];
    
    NSData * imageData = each[DICT_FOOD_IMAGE_KEY];
    
    cell.imageView.image = [UIImage imageWithData:imageData];
    
    
    
    return cell;
    
}



//使用者按下店家照片
- (IBAction)shopImageDidTapped:(id)sender {
    
    photoSavePlace = 1;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Please choose image source:" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self launchImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        
    }];
    UIAlertAction *library = [UIAlertAction actionWithTitle:@"Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self launchImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:camera];
    [alert addAction:library];
    [alert addAction:cancel];
    [self presentViewController:alert animated:true completion:nil];

    
    
}


//使用者按下食物照片

- (IBAction)foodItemImageDidTapped:(id)sender {
    
    photoSavePlace = 2;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Please choose image source:" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self launchImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        
    }];
    UIAlertAction *library = [UIAlertAction actionWithTitle:@"Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self launchImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:camera];
    [alert addAction:library];
    [alert addAction:cancel];
    [self presentViewController:alert animated:true completion:nil];
    
    
    
}




- (void) launchImagePickerWithSourceType:
(UIImagePickerControllerSourceType) soureceType{
    
    if ([UIImagePickerController isSourceTypeAvailable:soureceType] == false) { //check sourceType is existence?
        NSLog(@"Invalid Source Type.");
        return;
    }
    
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.sourceType = soureceType;
    picker.mediaTypes = @[@"public.image",@"public.movie"]; // mediaTypes：傳入照片(public.image)/傳入影片public.movie
    //        picker.mediaTypes = @[(NSString*)kUTTypeImage,(NSString*)kUTTypeMovie]; //意義同上程式
    
    
    picker.delegate = self;
    [self presentViewController:picker animated:true completion:nil];
    
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    if (image == nil) {
        //當拍照時拿不到上面的(UIImagePickerControllerEditedImage)時，就改拿下面的(UIImagePickerControllerOriginalImage)
        image = info[UIImagePickerControllerOriginalImage]; //照像時圖片為原圖
    }
    
    //拿到最後版本的image
    UIImage *resizeImage = [self resizeFromImage:image];
    
    
    // show預覽圖
    if (photoSavePlace == 1) {
         _shopImageView.image = resizeImage;
    }else{
        _shopFoodIconView.image = resizeImage;
    }
    
    
    
    
    [self savaWithImage:resizeImage];
    
    
    //目前檢查用
    NSData *imageData = UIImageJPEGRepresentation(resizeImage, 0.5);
    
    
    
    NSLog(@"imageData: %fx%f (%lu bytes)",resizeImage.size.width,resizeImage.size.height,imageData.length);
    
    [picker dismissViewControllerAnimated:true completion:nil]; //記得加否則選下一張照片時會沒有反應(imagepicker會沒反應)
    
}

- (UIImage*) resizeFromImage:(UIImage*) sourceImage {
    
    CGFloat maxLength = 1024.0;
    
    CGSize targetSize;
    UIImage *finalImage = nil;
    
    // Check if it is necessary to resize of will use original Image
    if (sourceImage.size.width <= maxLength && sourceImage.size.height < 1024) {
        finalImage = sourceImage;
        
        // 解決圖片檔案很小無法上傳的問題
        targetSize = sourceImage.size;
        
    } else {
        // Will do resize here,and decide final size first.
        if (sourceImage.size.width >= sourceImage.size.height) {
            
            // Width >= Height
            CGFloat ratio = sourceImage.size.width / maxLength;
            targetSize = CGSizeMake(maxLength, sourceImage.size.height /ratio);
            
        }else {
            
            // Height >= Width
            CGFloat ratio = sourceImage.size.height / maxLength;
            targetSize = CGSizeMake(sourceImage.size.width /ratio,maxLength);
        }
        
        // Do resize job here.
        UIGraphicsBeginImageContext(targetSize); //創造一塊虛擬畫布
        [sourceImage drawInRect:CGRectMake(0, 0, targetSize.width,targetSize.height)]; //drawInRect：畫在targetSize中
        finalImage = UIGraphicsGetImageFromCurrentImageContext(); //取出
        UIGraphicsEndImageContext(); // (Important)：記得釋放：因為此為C中的方法
    }
    
    // Add frame to image
    UIGraphicsBeginImageContext(targetSize);
    [finalImage drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    
    
    //    [text drawAtPoint:CGPointZero withAttributes:attributes];
    finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); // Important
    
    return finalImage;
}


// 照片存入相簿中
- (void) savaWithImage:(UIImage*)image {
    
    // Sava as a file
    // 取得PNG檔：找到路徑
    NSData *imageData = UIImagePNGRepresentation(image);
    NSURL *doucumentsURL = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    // 決定檔名
    NSString *filename = [NSString stringWithFormat:@"%@.png",[NSDate date]];
    // 路徑檔名結合
    NSURL *fullFilePathURL = [doucumentsURL URLByAppendingPathComponent:filename];
    // 存入
    // atomically：存檔時系統會先寫入暫存檔，當所有資料寫完時，系統才會rename成真正的檔名
    [imageData writeToURL:fullFilePathURL atomically:true];
    NSLog(@"Documents: %@",doucumentsURL); //驗證是否有存入用
    
    // Sava to photos library
    
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        // 異動的地方，包在此block中
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        if (success) {
            NSLog(@"Success");
        } else {
            NSLog(@"Write error: %@",error);
        }
        
    }];
    
    // 影片寫入，參考內建裝置p66(自已寫)
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
