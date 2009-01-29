Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0THcOPg221725 for <xfs@oss.sgi.com>; Thu, 29 Jan 2009 11:38:24 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 84DC18F8050
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2009 09:37:40 -0800 (PST)
Message-Id: <B82FFEC6-1110-46F4-99D6-9A37A054E27D@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <3FDD97ECDAEB29439D3A8B494349EB490B9FA3F1@CHG-EMB-01.aba.ad.abanet.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: XFS_kupcRep: XFS_bufFind failed 0
Date: Thu, 29 Jan 2009 11:37:39 -0600
References: <3FDD97ECDAEB29439D3A8B494349EB490B9FA3F1@CHG-EMB-01.aba.ad.abanet.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "Carmichael, Harry" <CarmichH@staff.abanet.org>
Cc: xfs@oss.sgi.com


On Jan 29, 2009, at 9:50 AM, Carmichael, Harry wrote:

> We are getting the following errors on our TeamStie system, which  
> runs XFS.
> Running on Solaris 8 (117350-38) on a 280R ( sun4u, sparc SUNW,Sun- 
> Fire-280R ).

It doesn't look like it's the XFS filesystem you're talking about.
This mailing list is about the "XFS linux filesystem".
Sorry, no help here.

Felix

>
> Jan 28 15:55:14 tsprod wfs: [ID 701730 kern.notice] 1233179714 -  
> 33645:
> Jan 28 15:55:14 tsprod wfs: [ID 209484 kern.notice] Interwoven  
> TeamSite server is not responding
> Jan 28 15:57:35 tsprod wfs: [ID 701730 kern.notice] 1233179855 -  
> 883178:
> Jan 28 15:57:35 tsprod wfs: [ID 654549 kern.notice] XFS_kupcRep:  
> XFS_bufFind failed 0
> Jan 28 15:57:35 tsprod wfs: [ID 701730 kern.notice] 1233179855 -  
> 884907:
> Jan 28 15:57:35 tsprod wfs: [ID 497422 kern.notice] Interwoven  
> TeamSite server is ok
> Jan 28 15:57:36 tsprod wfs: [ID 701730 kern.notice] 1233179856 -  
> 29231:
> Jan 28 15:57:36 tsprod wfs: [ID 654549 kern.notice] XFS_kupcRep:  
> XFS_bufFind failed 0
> Jan 28 16:08:49 tsprod wfs: [ID 701730 kern.notice] 1233180529 -  
> 659814:
> Jan 28 16:08:49 tsprod wfs: [ID 209484 kern.notice] Interwoven  
> TeamSite server is not responding
> Jan 28 16:09:20 tsprod wfs: [ID 701730 kern.notice] 1233180560 -  
> 337435:
> Jan 28 16:09:20 tsprod wfs: [ID 497422 kern.notice] Interwoven  
> TeamSite server is ok
> Jan 28 16:09:29 tsprod wfs: [ID 701730 kern.notice] 1233180569 -  
> 952754:
> Jan 28 16:09:29 tsprod wfs: [ID 654549 kern.notice] XFS_kupcRep:  
> XFS_bufFind failed 0
>
> Any ideas ?
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
