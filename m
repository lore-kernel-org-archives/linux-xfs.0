Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 30 Oct 2007 21:13:20 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9V4CvJK015907
	for <xfs@oss.sgi.com>; Tue, 30 Oct 2007 21:13:00 -0700
Message-ID: <472800CC.8000904@sandeen.net>
Date: Tue, 30 Oct 2007 23:13:00 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Default mount options (that suck less).
References: <20071029075657.GA84369978@melbourne.sgi.com>	 <4725E84D.3030609@sandeen.net> <4725F6C0.3020303@theendofthetunnel.de>	 <4725F732.2060509@sandeen.net>	 <1193733605.9551.18.camel@localhost.localdomain> <1193803905.3862.108.camel@edge.yarra.acx>
In-Reply-To: <1193803905.3862.108.camel@edge.yarra.acx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nscott@aconex.com
Cc: Stewart Smith <stewart@flamingspork.com>, Hannes Dorbath <light@theendofthetunnel.de>, Niv Sardi <xaiki@sgi.com>, xfs@oss.sgi.com

Nathan Scott wrote:
> On Tue, 2007-10-30 at 19:40 +1100, Stewart Smith wrote:
>> Probably SELinux+Beagle attributes?
>>
>> Attribute "Beagle.Fingerprint" has a 25 byte value
>> Attribute "Beagle.Uid" has a 22 byte value
>> Attribute "Beagle.MTime" has a 14 byte value
>> Attribute "Beagle.Filter" has a 36 byte value
>> Attribute "Beagle.AttrTime" has a 14 byte value
>>
>> That's 111bytes just for values... 
> 
> and another ~70 bytes for the names.

bleah!

Ok, so we can have a "beagle" filesystem type in mkfs.xfs.conf ;-)

-Eric
