Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Feb 2008 13:13:25 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m15LDGVJ027751
	for <xfs@oss.sgi.com>; Tue, 5 Feb 2008 13:13:20 -0800
Message-ID: <47A8D156.8060405@sgi.com>
Date: Wed, 06 Feb 2008 08:12:54 +1100
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: mkfs.xfs doesn't detect size of storage correctly
References: <20080129093201.GA16203@citd.de> <47A87877.1050106@sandeen.net>
In-Reply-To: <47A87877.1050106@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Matthias Schniedermeyer <ms@citd.de>, xfs@oss.sgi.com



Eric Sandeen wrote:
> Matthias Schniedermeyer wrote:
> 
>> There is roughly 1/3 missing.
> 
> SGI, have you settled on a fix for this? 

Yes, Barry is reviewing and testing your proposed fix. The delay was caused
by most of the XFS team attending LCA last week. .. sorry.

We'll get a new package out onto OSS asap.

Cheers
-- Mark


> Latest released xfsprogs,
> 2.9.5 has this problem, and I've put it in rawhide; it's also in the F9
> alpha spin.  Should I revert to 2.9.4 if you don't have plans to fix it
> soon?
> 
> Nothing indicates to the user that their fs was misformatted, and there
> will be a growing number fileystems missing a substantial portion of
> their space out there....
> 
> -Eric
> 
> 
