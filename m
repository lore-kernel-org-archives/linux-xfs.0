Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 19 Nov 2006 19:25:59 -0800 (PST)
Received: from prod.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAK3PnaG030587
	for <xfs@oss.sgi.com>; Sun, 19 Nov 2006 19:25:51 -0800
Subject: Re: [PATCH] (and bad attr2 bug) - pack xfs_sb_t for 64-bit arches
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <45610761.50009@sandeen.net>
References: <455CB54F.8080901@sandeen.net>
	 <BB70F203E29C2D37A2F727C8@timothy-shimmins-power-mac-g5.local>
	 <20061117023946.GN11034@melbourne.sgi.com>
	 <CEB981736A0E8C7DF9ABD7C8@timothy-shimmins-power-mac-g5.local>
	 <20061117055521.GS11034@melbourne.sgi.com>
	 <52841.10.0.0.2.1163745285.squirrel@sandeen.net>
	 <1163746343.4695.152.camel@edge>
	 <48064.10.0.0.2.1163776850.squirrel@sandeen.net>
	 <1163977907.4695.157.camel@edge>  <45610761.50009@sandeen.net>
Content-Type: text/plain
Date: Mon, 20 Nov 2006 14:00:28 +1100
Message-Id: <1163991628.4695.169.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: David Chinner <dgc@sgi.com>, Timothy Shimmin <tes@sgi.com>, xfs@oss.sgi.com

On Sun, 2006-11-19 at 19:39 -0600, Eric Sandeen wrote:
> ...
> but it can't just be properly padded in the kernel and leave it at that, 
> can it?

I think it can.

>  If so won't attr2 filesystems on x86_64 suddenly start 
> appearing to be attr2?

What problem do you see resulting from that though?

cheers.

-- 
Nathan
