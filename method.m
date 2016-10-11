#import <objc/runtime.h>

@implementation className

-(void)printObjectDesc:(id)obj
{
    id obj = self;
    //display methods on object
    const char* curClass = object_getClassName(obj);
    unsigned int mc = 0;
    Method * mlist = class_copyMethodList(object_getClass(obj), &mc); //mem must be freed
    for(int i=0;i<mc;i++)
    {
        char c[10];
        method_getReturnType(mlist[i], c, 10);
        NSString* typeName = [NSObject getStringForVarType:c];
        int arg_count = method_getNumberOfArguments(mlist[i]);
        NSString* argStr = @"";
        for(int j = 0; j < arg_count; j++)
        {
            char* argType = method_copyArgumentType(mlist[i], j); //mem must be freed
            NSString* argTypeName = [NSObject getStringForVarType:argType];
            argStr = [NSString stringWithFormat:@"%@, %@",argStr,argTypeName];
            free(argType);
        }
        NSLog(@"%s: Meth: -(%@)%s(%@)", curClass,typeName, sel_getName(method_getName(mlist[i])),argStr);
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
            NSString* propertyType = [self getStringForVarType:propType];


            free(propType);

            NSLog(@"%s: Prop: (%@)%s",curClass,propertyType,propName/*,ivrid*/   );
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

-(NSString*)getStringForVarType:(char*)type
{
    NSString* result;
    switch (type[0]) {
        case _C_ID:       result = @"id"; break;                 //'@'
        case _C_CLASS:    result = @"Class"; break;              //'#'
        case _C_SEL:      result = @"selector"; break;           //':'
        case _C_CHR:      result = @"char"; break;               //'c'
        case _C_UCHR:     result = @"unsigned char"; break;      //'C'
        case _C_SHT:      result = @"short"; break;              //'s'
        case _C_USHT:     result = @"unsigned short"; break;     //'S'
        case _C_INT:      result = @"int"; break;                //'i'
        case _C_UINT:     result = @"unsigned int"; break;       //'I'
        case _C_LNG:      result = @"long"; break;               //'l'
        case _C_ULNG:     result = @"unsigned long"; break;      //'L'
        case _C_LNG_LNG:  result = @"long long"; break;          //'q'
        case _C_ULNG_LNG: result = @"unsigned long long"; break; //'Q'
        case _C_FLT:      result = @"float"; break;              //'f'
        case _C_DBL:      result = @"double"; break;             //'d'
        case _C_BFLD:     result = @"_C_BFLD?"; break;           //'b'
        case _C_BOOL:     result = @"BOOL"; break;               //'B'
        case _C_VOID:     result = @"void"; break;               //'v'
        case _C_UNDEF:    result = @"Undefined"; break;          //'?'
        case _C_PTR:      result = @"Pointer"; break;            //'^'
        case _C_CHARPTR:  result = @"char*"; break;              //'*'
        case _C_ATOM:     result = @"_C_ATOM"; break;            //'%'
        case _C_ARY_B:    result = @"_C_ARY_B"; break;           //'['
        case _C_ARY_E:    result = @"_C_ARY_E"; break;           //']'
        case _C_UNION_B:  result = @"_C_UNION_B"; break;         //'('
        case _C_UNION_E:  result = @"_C_UNION_E"; break;         //')'
        case _C_STRUCT_B: result = @"_C_STRUCT_B"; break;        //'{'
        case _C_STRUCT_E: result = @"_C_STRUCT_E"; break;        //'}'
        case _C_VECTOR:   result = @"_C_VECTOR"; break;          //'!'
        case _C_CONST:    result = @"_C_CONST"; break;           //'r'
        default:
            result = [NSString stringWithCString:type encoding:[NSString defaultCStringEncoding]];
    }
    return result;
}
@end
