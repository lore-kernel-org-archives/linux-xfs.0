Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 26 Nov 2006 22:22:02 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAR6LpaG031812
	for <linux-xfs@oss.sgi.com>; Sun, 26 Nov 2006 22:21:54 -0800
Message-ID: <456A8452.9060602@sgi.com>
Date: Mon, 27 Nov 2006 17:23:14 +1100
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: TAKE 958534 - [clone 958472] dmf does not work with mangrove
 1.0 enhanced dmapi module
References: <456A1CD4.8000301@sgi.com> <20061127055657.GB1374@infradead.org>
In-Reply-To: <20061127055657.GB1374@infradead.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: sgi.bugs.xfs@engr.sgi.com, linux-xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Mon, Nov 27, 2006 at 10:01:40AM +1100, Vlad Apostolov wrote:
>   
>> DMF doesn't work with mangrove 1.0 because of uninitialized dt_dev in 
>> xfs_ip_to_stat()
>>     
>
> What's mangrove?
>   
The mangrove tree is an internal tree we are
using to track top-of-xfs stuff backported to the SLES10 kernel.
