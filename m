Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DC2A17F5F
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 13:21:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B8BF3304053
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 11:21:19 -0700 (PDT)
Received: from mail-ea0-f182.google.com (mail-ea0-f182.google.com
	[209.85.215.182]) by cuda.sgi.com with ESMTP id
	CL07taQfxHDqBQkH (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 Aug 2013 11:21:18 -0700 (PDT)
Received: by mail-ea0-f182.google.com with SMTP id o10so537782eaj.27
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 11:21:17 -0700 (PDT)
Message-ID: <520D1BD8.9090208@gmail.com>
Date: Thu, 15 Aug 2013 19:20:08 +0100
From: Ric Wheeler <ricwheeler@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: 091, 240, 268 fix for xfs on 4k sector hard
	drive
References: <20130724143208.34b77534@oracle.com>
	<20130724235739.GR19986@dastard>
	<51F0AB56.7020705@hardwarefreak.com>
In-Reply-To: <51F0AB56.7020705@hardwarefreak.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com
Cc: Dwight Engen <dwight.engen@oracle.com>, xfs@oss.sgi.com

On 07/25/2013 05:36 AM, Stan Hoeppner wrote:
> AFAIK there are no native 4K sector drives on the market yet.  All of
> the currently shipping models with physical 4K sectors are "Advanced
> Format" drives.  The Advanced Format standard specifies 4K physical
> sectors -internal- to the drive, but with traditional 512B LBA addressing.

There are some (SAS) drives that do only 4K sectors. Not sure how popular they are,

Ric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
