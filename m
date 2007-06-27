Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 27 Jun 2007 16:24:42 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5RNObtL010469
	for <xfs@oss.sgi.com>; Wed, 27 Jun 2007 16:24:38 -0700
Date: Wed, 27 Jun 2007 19:24:38 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Fastest Chunk Size w/XFS For MD Software RAID = 1024k
In-Reply-To: <Pine.LNX.4.64.0706271920350.29111@p34.internal.lan>
Message-ID: <Pine.LNX.4.64.0706271924200.29111@p34.internal.lan>
References: <Pine.LNX.4.64.0706271918010.29111@p34.internal.lan>
 <Pine.LNX.4.64.0706271920350.29111@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-raid@vger.kernel.org, xfs@oss.sgi.com
Cc: Alan Piszcz <ap@solarrain.com>

For the e-mail archives:

p34-128k-chunk,15696M,77236.3,99,445653,86.3333,192267,34.3333,78773.7,99,524463,41,594.9,0,16:100000:16/64,1298.67,10.6667,5964.33,17.3333,3035.67,18.3333,1512,13.6667,5334.33,16,2634.67,19
p34-512k-chunk,15696M,78383,99,436842,86,162969,27,79624,99,486892,38,583.0,0,16:100000:16/64,2019,17,9715,29,4272,23,2250,22,17095,45,3691,30
p34-1024k-chunk,15696M,77672.3,99,455267,87.3333,183772,29.6667,79601.3,99,578225,43.3333,595.933,0,16:100000:16/64,2085.67,18,12953,39,3908.33,23.3333,2375.33,23.3333,18492,51.6667,3388.33,27
p34-4096k-chunk,15696M,33791.1,43.5556,176630,37.3333,72235.1,11.5556,34424.9,44,247925,18.2222,271.644,0,16:100000:16/64,560,4.88889,2928,8.88889,1039.56,5.77778,571.556,5.33333,1729.78,5.33333,1289.33,9.33333


On Wed, 27 Jun 2007, Justin Piszcz wrote:

> For drives with 16MB of cache (in this case, raptors).
>
> Justin.
>
> On Wed, 27 Jun 2007, Justin Piszcz wrote:
>
>> The results speak for themselves:
>> 
>> http://home.comcast.net/~jpiszcz/chunk/index.html
>> 
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
>
>
