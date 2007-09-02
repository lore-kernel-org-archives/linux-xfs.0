Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Sep 2007 15:59:20 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l82MxG4p019923
	for <xfs@oss.sgi.com>; Sun, 2 Sep 2007 15:59:18 -0700
Subject: Re: ZFS, XFS, and EXT4 compared
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <1188659243.4430.8.camel@auctoritas.fs3.ph>
References: <1188454611.23311.13.camel@toonses.gghcwest.com>
	 <1188457666.24970.94.camel@edge.yarra.acx>
	 <20070830132002.GA4086@infradead.org>
	 <1188513751.24970.109.camel@edge.yarra.acx>
	 <1188659243.4430.8.camel@auctoritas.fs3.ph>
Content-Type: text/plain
Date: Mon, 03 Sep 2007 09:00:33 +1000
Message-Id: <1188774034.24970.123.camel@edge.yarra.acx>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Federico Sevilla III <jijo@fs3.ph>
Cc: xfs@oss.sgi.com

On Sat, 2007-09-01 at 23:07 +0800, Federico Sevilla III wrote:
> 
> 
> Am I reading the thread correctly that even with this message showing
> up, I still need to mount with nobarrier explicitly to improve
> performance?
> 

No, thats not needed if XFS explicitly says its not using barriers.

cheers.

--
Nathan
