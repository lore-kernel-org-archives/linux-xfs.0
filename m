Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Nov 2006 06:44:38 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAEEiSaG019650
	for <xfs@oss.sgi.com>; Tue, 14 Nov 2006 06:44:30 -0800
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B7003D1C909C
	for <xfs@oss.sgi.com>; Tue, 14 Nov 2006 06:43:40 -0800 (PST)
Message-ID: <4559D61B.3060302@sandeen.net>
Date: Tue, 14 Nov 2006 08:43:39 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: RHEL 4 Compatible Kernel Module Code
References: <1163434210.25484.14.camel@houuc8> <4558B4DC.3050406@sandeen.net> <30F3263F8874E466D6206C56@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <30F3263F8874E466D6206C56@timothy-shimmins-power-mac-g5.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: "Stephen C. Rigler" <srigler@marathonoil.com>, xfs@oss.sgi.com

Timothy Shimmin wrote:
> Hi Eric,

> If you are referring to Mandy's incore extent changes,
> I don't see them in sles9 or sles10.
> 
> Having a quick look she has about 5 Mods.

Ok, that's what I thought... pretty big change for a stable branch.  Though I'm 
surprised that it's not in sles10!

I do have an updated rhel4 module rpm going now; there were about 8 more patches 
that the sgi guys deemed worthy for sles9, so I merged them in.  Tidying up the 
specfile and need to do some tests; if anyone wants a preview, let me know 
off-list.  I hope to get it tested & available in a day or two.

-Eric
