Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 408C67F51
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 18:30:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 30251304062
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 16:30:47 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id AGa8x6YLvInWdVv4
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 16:30:47 -0700 (PDT)
Message-ID: <520D64A9.1060209@hardwarefreak.com>
Date: Thu, 15 Aug 2013 18:30:49 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: 091, 240, 268 fix for xfs on 4k sector hard
	drive
References: <20130724143208.34b77534@oracle.com>
	<20130724235739.GR19986@dastard>
	<51F0AB56.7020705@hardwarefreak.com> <520D1BD8.9090208@gmail.com>
In-Reply-To: <520D1BD8.9090208@gmail.com>
Reply-To: stan@hardwarefreak.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ric Wheeler <ricwheeler@gmail.com>
Cc: Dwight Engen <dwight.engen@oracle.com>, xfs@oss.sgi.com

On 8/15/2013 1:20 PM, Ric Wheeler wrote:
> On 07/25/2013 05:36 AM, Stan Hoeppner wrote:
>> AFAIK there are no native 4K sector drives on the market yet.  All of
>> the currently shipping models with physical 4K sectors are "Advanced
>> Format" drives.  The Advanced Format standard specifies 4K physical
>> sectors -internal- to the drive, but with traditional 512B LBA
>> addressing.
> 
> There are some (SAS) drives that do only 4K sectors. Not sure how
> popular they are,

Google returns nothing on native 4KB drives at any drive vendor site,
other than two transition documents at Seagate and Toshiba extolling the
benefits of 512e technology.

I can't find a press release.  If native 4KB drives are indeed
available, the vendors sure don't appear too eager to tell the world
about them.  The drives of which you speak, are these engineering
samples, OEM production only (EMC/IBM/etc), or general availability?

Which vendor makes the drives of which you speak?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
