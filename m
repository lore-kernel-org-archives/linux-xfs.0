Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n63FNswN175173 for <xfs@oss.sgi.com>; Fri, 3 Jul 2009 10:23:54 -0500
Received: from mail-yx0-f203.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5717B9DA7F7
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2009 08:30:57 -0700 (PDT)
Received: from mail-yx0-f203.google.com (mail-yx0-f203.google.com
	[209.85.210.203]) by cuda.sgi.com with ESMTP id
	L8ia3ItgCYqvIDFO for <xfs@oss.sgi.com>;
	Fri, 03 Jul 2009 08:30:57 -0700 (PDT)
Received: by yxe41 with SMTP id 41so3235337yxe.20
	for <xfs@oss.sgi.com>; Fri, 03 Jul 2009 08:24:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6efe08af0907030741q3befbfc5m8c208249dd5cad15@mail.gmail.com>
References: <7778c60e0907030557j357f88e5g4ab3ce0d3377bb41@mail.gmail.com>
	<6efe08af0907030741q3befbfc5m8c208249dd5cad15@mail.gmail.com>
Date: Fri, 3 Jul 2009 20:54:24 +0530
Message-ID: <7778c60e0907030824k723c4ddetdead0a1d43835476@mail.gmail.com>
Subject: Re: Clustered version of XFS
From: Tharindu Rukshan Bamunuarachchi <tharindu@sentstory.com>
Reply-To: tharindu@sentstory.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "Vitaly V. Ch" <vitaly.v.ch@gmail.com>, sandeen@sandeen.net
Cc: xfs@oss.sgi.com

Thankx lot for your responses.


I recently send inqury over SGI website. Still no-reply.
If there is someone related to SGI's CXFS in this list, please be kind
enough to provide contact details.
one of the world largest stock market likes to try out CXFS ....

__
tharindu



On Fri, Jul 3, 2009 at 8:11 PM, Vitaly V. Ch<vitaly.v.ch@gmail.com> wrote:
> On Fri, Jul 3, 2009 at 3:57 PM, Tharindu Rukshan
> Bamunuarachchi<tharindu@sentstory.com> wrote:
>> we are using XFS high speed transaction processing system.
>>
>> we are very happy with XFS performance compared to ZFS, EXT3, JFS etc.
>>
>> i have two questions regarding XFS ...
>>
>> 1. Is there any cluster version of XFS. (e.g. like GFS, Luste, GPFS)
>
> Yes. Your need cxfs.
>
>> 2. I am currently using my root partition as XFS. but i need to modify
>> XFS source code and reload module without rebooting machine.
>> =A0 =A0Is there anyway to play with XFS source/module while using XFS
>> module for mounted file system ....?
>
> Yes. duplicate Your code and use non-reloadable copy for root fs and
> reloadable under other name ("my_xfs" for example) for other
> partitions.
>
>>
>>
>> cheers
>> __
>> tharindu
>>
>
> \\wbr Vitaly Chernookiy
>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
