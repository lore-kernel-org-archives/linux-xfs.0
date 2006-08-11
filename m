Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Aug 2006 11:39:54 -0700 (PDT)
Received: from smtp107.sbc.mail.mud.yahoo.com (smtp107.sbc.mail.mud.yahoo.com [68.142.198.206])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7BIdUDW014888
	for <linux-xfs@oss.sgi.com>; Fri, 11 Aug 2006 11:39:38 -0700
Date: Fri, 11 Aug 2006 11:38:58 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: mkfs.xfs
Message-ID: <20060811183858.GA28538@tuatara.stupidest.org>
References: <684a75330608110447k16c4a079q74ab3d4deac0a273@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <684a75330608110447k16c4a079q74ab3d4deac0a273@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Katt <katt.man@gmail.com>
Cc: linux-xfs@oss.sgi.com

On Fri, Aug 11, 2006 at 12:47:47PM +0100, Katt wrote:

> It is posibile to recovery a xfs partition after I make only
> mkfs.xfs?

Not really, if you know what file(s) you lost you could do a heuristic
scan for them.  I've done this many times for photos lost on CF cards
in cameras for example.
