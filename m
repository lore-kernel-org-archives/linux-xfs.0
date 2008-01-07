Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Jan 2008 20:41:44 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130] (may be forged))
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m074fUNv021362
	for <xfs@oss.sgi.com>; Sun, 6 Jan 2008 20:41:34 -0800
Received: from cxfsmac10.melbourne.sgi.com (cxfsmac10.melbourne.sgi.com [134.14.55.100]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id PAA26818; Mon, 7 Jan 2008 15:41:15 +1100
Message-ID: <4781AD6A.2000007@sgi.com>
Date: Mon, 07 Jan 2008 15:41:14 +1100
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] dmapi: kill last 2.4 compat leftovers
References: <20071130093909.GB2949@lst.de> <20071221063703.GA23706@lst.de>
In-Reply-To: <20071221063703.GA23706@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> Any reason this didn't get in yet?

No its in now, thanks for the reminder.

Don

> On Fri, Nov 30, 2007 at 10:39:09AM +0100, Christoph Hellwig wrote:
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>
>> Index: linux-2.6-xfs/fs/dmapi/dmapi_register.c
>> ===================================================================
>> --- linux-2.6-xfs.orig/fs/dmapi/dmapi_register.c	2007-09-29 11:49:22.000000000 +0200
>> +++ linux-2.6-xfs/fs/dmapi/dmapi_register.c	2007-09-29 11:49:39.000000000 +0200
