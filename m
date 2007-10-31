Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 30 Oct 2007 21:12:15 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9V4Bjb8015647
	for <xfs@oss.sgi.com>; Tue, 30 Oct 2007 21:11:48 -0700
Subject: Re: Default mount options (that suck less).
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <1193733605.9551.18.camel@localhost.localdomain>
References: <20071029075657.GA84369978@melbourne.sgi.com>
	 <4725E84D.3030609@sandeen.net> <4725F6C0.3020303@theendofthetunnel.de>
	 <4725F732.2060509@sandeen.net>
	 <1193733605.9551.18.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 31 Oct 2007 15:11:45 +1100
Message-Id: <1193803905.3862.108.camel@edge.yarra.acx>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stewart Smith <stewart@flamingspork.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Hannes Dorbath <light@theendofthetunnel.de>, Niv Sardi <xaiki@sgi.com>, xfs@oss.sgi.com

On Tue, 2007-10-30 at 19:40 +1100, Stewart Smith wrote:
> 
> Probably SELinux+Beagle attributes?
> 
> Attribute "Beagle.Fingerprint" has a 25 byte value
> Attribute "Beagle.Uid" has a 22 byte value
> Attribute "Beagle.MTime" has a 14 byte value
> Attribute "Beagle.Filter" has a 36 byte value
> Attribute "Beagle.AttrTime" has a 14 byte value
> 
> That's 111bytes just for values... 

and another ~70 bytes for the names.

-- 
Nathan
