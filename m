Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n659qMfs019509 for <xfs@oss.sgi.com>; Sun, 5 Jul 2009 04:52:23 -0500
Received: from mail-yx0-f203.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BC2959E0371
	for <xfs@oss.sgi.com>; Sun,  5 Jul 2009 02:59:36 -0700 (PDT)
Received: from mail-yx0-f203.google.com (mail-yx0-f203.google.com
	[209.85.210.203]) by cuda.sgi.com with ESMTP id
	eLG3XHW5skVx85mt for <xfs@oss.sgi.com>;
	Sun, 05 Jul 2009 02:59:36 -0700 (PDT)
Received: by yxe41 with SMTP id 41so4408848yxe.20
	for <xfs@oss.sgi.com>; Sun, 05 Jul 2009 02:52:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8B9C6BFA-0092-4AEA-9552-59A9291B68D9@sgi.com>
References: <7778c60e0907030557j357f88e5g4ab3ce0d3377bb41@mail.gmail.com>
	<6efe08af0907030741q3befbfc5m8c208249dd5cad15@mail.gmail.com>
	<7778c60e0907030824k723c4ddetdead0a1d43835476@mail.gmail.com>
	<8B9C6BFA-0092-4AEA-9552-59A9291B68D9@sgi.com>
Date: Sun, 5 Jul 2009 15:22:54 +0530
Message-ID: <7778c60e0907050252x4ca88f51vca131ce05be47f01@mail.gmail.com>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: sandeen@sandeen.net, "Vitaly V. Ch" <vitaly.v.ch@gmail.com>, xfs@oss.sgi.com

thankx,

i want to believe that CXFS will perform same or better than XFS.
__
tharindu



On Sun, Jul 5, 2009 at 9:30 AM, Felix Blyakher<felixb@sgi.com> wrote:
>
> On Jul 3, 2009, at 10:24 AM, Tharindu Rukshan Bamunuarachchi wrote:
>
>> Thankx lot for your responses.
>>
>>
>> I recently send inqury over SGI website. Still no-reply.
>
> Today is a national holiday in US, and SGI was closed yesterday.
> I'm sure somebody will get back to you on Monday.
>
>> If there is someone related to SGI's CXFS in this list, please be kind
>> enough to provide contact details.
>
> I forwarded you inquiry to right channels. You should hear from
> SGI soon.
>
>> one of the world largest stock market likes to try out CXFS ....
>
> Hope you will like CXFS.
>
> Felix
>
>> __
>> tharindu
>>
>>
>>
>> On Fri, Jul 3, 2009 at 8:11 PM, Vitaly V. Ch<vitaly.v.ch@gmail.com> wrot=
e:
>>>
>>> On Fri, Jul 3, 2009 at 3:57 PM, Tharindu Rukshan
>>> Bamunuarachchi<tharindu@sentstory.com> wrote:
>>>>
>>>> we are using XFS high speed transaction processing system.
>>>>
>>>> we are very happy with XFS performance compared to ZFS, EXT3, JFS etc.
>>>>
>>>> i have two questions regarding XFS ...
>>>>
>>>> 1. Is there any cluster version of XFS. (e.g. like GFS, Luste, GPFS)
>>>
>>> Yes. Your need cxfs.
>>>
>>>> 2. I am currently using my root partition as XFS. but i need to modify
>>>> XFS source code and reload module without rebooting machine.
>>>> =A0 Is there anyway to play with XFS source/module while using XFS
>>>> module for mounted file system ....?
>>>
>>> Yes. duplicate Your code and use non-reloadable copy for root fs and
>>> reloadable under other name ("my_xfs" for example) for other
>>> partitions.
>>>
>>>>
>>>>
>>>> cheers
>>>> __
>>>> tharindu
>>>>
>>>
>>> \\wbr Vitaly Chernookiy
>>>
>>>> _______________________________________________
>>>> xfs mailing list
>>>> xfs@oss.sgi.com
>>>> http://oss.sgi.com/mailman/listinfo/xfs
>>>>
>>>
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
