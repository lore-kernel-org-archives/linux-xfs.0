Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Feb 2008 20:42:15 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1K4g1x2015192
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 20:42:07 -0800
Received: from cxfsmac10.melbourne.sgi.com (cxfsmac10.melbourne.sgi.com [134.14.55.100]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id PAA13892; Wed, 20 Feb 2008 15:42:21 +1100
Message-ID: <47BBAFAC.3070803@sgi.com>
Date: Wed, 20 Feb 2008 15:42:20 +1100
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH, Updated] remove shouting-indirection macros from xfs_sb.h
References: <47AD44D3.4060503@sandeen.net> <47AE0419.6050000@sandeen.net> <47BB780A.5090705@sandeen.net>
In-Reply-To: <47BB780A.5090705@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Eric Sandeen wrote:
>> (missed one instance of XFS_SB_VERSION_HASLOGV2)
>>
>> Remove macro-to-small-function indirection from xfs_sb.h,
>> and remove some which are completely unused.
>>
>> Some day I'll get them all...
Need to get them all before people add NEW ONES for new inlines :)

> Christoph likes it.  does sgi?
Looks good to me, I'll get it into the tree.

Don
