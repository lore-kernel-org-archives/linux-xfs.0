Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 17 Dec 2006 16:59:27 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kBI0xGqw018038
	for <xfs@oss.sgi.com>; Sun, 17 Dec 2006 16:59:17 -0800
Message-Id: <200612180058.LAA20709@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: RE: LEAFN node level is 1 warning in xfs_repair
Date: Mon, 18 Dec 2006 12:04:09 +1100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
In-Reply-To: <200612151136.47182.krienke@uni-koblenz.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Rainer Krienke' <krienke@uni-koblenz.de>, xfs@oss.sgi.com

 

> -----Original Message-----
> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] 
> On Behalf Of Rainer Krienke
> Sent: Friday, 15 December 2006 9:37 PM
> To: xfs@oss.sgi.com
> Subject: LEAFN node level is 1 warning in xfs_repair
> 
> Hello,
> 
> I have a xfs filesystem on a SuSE SLES10 (kernel 2.6.16.21) 
> system that was 
> created just a week ago. Because I wanted to know how long it 
> might take to 
> run xfs_repair in case it might be needed I started 
> xfs_repair on it without 
> that I thought I would actually need it.
> 
> Now for several inodes xfs_repair reports in Phase 3 and 4 
> 
> LEAFN node level is 1 
> 
> warning. In the mailinglists I found that other people have the same 
> experience. 
> 
> The question is, if this warning anything serious that might 
> lead into a 
> filesystem corruption later. Or can I just forget about this warning?

It is a bogus warning that has been fixed in xfsprogs 2.8.15 and later.

You can forget about the warning.

Regards,
Barry.
