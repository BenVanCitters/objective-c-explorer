#import <objc/runtime.h>

@implementation className

-(void)printObjectDesc:(id)obj
{
    //display methods
    const char* curClass = object_getClassName(obj);
    unsigned int mc = 0;
    Method * mlist = class_copyMethodList(object_getClass(obj), &mc); //mem must be freed
    for(int i=0;i<mc;i++)
    {
            NSLog(@"%s: Meth: %s", curClass, sel_getName(method_getName(mlist[i])));
    }
    free(mlist);
    
    //display properties
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList(object_getClass(obj), &outCount); //mem must be freed
    for(int i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName)
        {
            char *propType = property_copyAttributeValue(property, "T"); //mem must be freed
            NSString* propertyType;
            switch (propType[0]) {
                case 'i': propertyType = @"int";                break;
                case 's': propertyType = @"short";              break;
                case 'l': propertyType = @"long";               break;
                case 'q': propertyType = @"long long";          break;
                case 'I': propertyType = @"unsigned int";       break;
                case 'S': propertyType = @"unsigned short";     break;
                case 'L': propertyType = @"unsigned long";      break;
                case 'Q': propertyType = @"unsigned long long"; break;
                case 'f': propertyType = @"float";              break;
                case 'd': propertyType = @"double";             break;
                case 'B': propertyType = @"BOOL";               break;
                default:
                    propertyType = [NSString stringWithCString:propType encoding:[NSString defaultCStringEncoding]];
            }
            free(propType);
            Ivar ivr =class_getInstanceVariable((Class)object_getClass(obj), propName);
            id ivrid = object_getIvar(obj, ivr);
        
            NSLog(@"%s: Prop: (%@)%s - %p",curClass,propertyType,propName,ivrid   );
        }
    }
    free(properties);
    
//trying to list the actual values in the properties in this object
//    unsigned int iVarCount;
//    Ivar* vars = class_copyIvarList([obj class], &iVarCount); //this mem must be freed
//    for(int i = 0; i < iVarCount; i++)
//    {
//        const char* ivrName = ivar_getName(vars[i]);
//        Ivar ivr =class_getInstanceVariable((Class)object_getClass(obj), ivrName);
//
//            id ivrid = object_getIvar(obj, ivr);
//            NSLog(@"ivar: %s - %@", ivrName,ivrid );
//    }
//    free(vars);
}

@end
