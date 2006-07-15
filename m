Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 15 Jul 2006 10:19:02 -0700 (PDT)
Received: from smtp.funpic.de (smtp.funpic.de [213.202.225.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6FHInDW009042
	for <xfs@oss.sgi.com>; Sat, 15 Jul 2006 10:18:49 -0700
Date: Sat, 15 Jul 2006 19:18:32 +0200
From: "A. Liemen" <maillist@liemen.net>
MIME-Version: 1.0
Subject: Re: Change internal to external log/journal
References: <20060710183437.BD681A0090E@smtp.funpic.de> <20060711015629.DE3012008DE@smtp.funpic.de>
In-Reply-To: <20060711015629.DE3012008DE@smtp.funpic.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Message-Id: <20060715171824.2F8C1A00A89@smtp.funpic.de>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Just for reference:

http://oss.sgi.com/archives/xfs/2001-07/msg00564.html

Worked like a charm.

Thanks Eric
Alex

Eric Sandeen schrieb:
> A. Liemen wrote:
>> Hi,
>>
>> is there a way to change an internal log/journal to an external one on 
>> an existing volume? (without loosing data / runnning mkfs)
>>
>> Thanks
>> Alex
>>
> 
> No supported option, but if you search through the list archives you'll 
> find -unsupported- instructions for doing it with xfs_db.
> 
> If it breaks, you get both pieces, etc etc :)
> 
> -Eric
