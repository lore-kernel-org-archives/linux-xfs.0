Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Sep 2007 20:14:08 -0700 (PDT)
Received: from ipmail02.adl2.internode.on.net (ipmail02.adl2.internode.on.net [203.16.214.141])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8L3E0gf011288
	for <xfs@oss.sgi.com>; Thu, 20 Sep 2007 20:14:02 -0700
Date: Fri, 21 Sep 2007 13:13:30 +1000
From: Jason White <jason@jasonjgw.net>
Subject: Re: xfs and Linux Linux 2.6.22 and Memory
Message-ID: <20070921031330.GA15134@jdc.jasonjgw.net>
References: <46F2E001.4040107@sandeen.net> <773373.46803.qm@web35703.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <773373.46803.qm@web35703.mail.mud.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Thu, Sep 20, 2007 at 07:14:23PM -0700, Mariella Petrini wrote:
> I was mostly curious, especially because In some cases
> after having created all the files I may not need to
> have all of them cached and I may need to availability
> of the RAM for other purposes.

I may be wrong, but as I understand it, if the RAM is needed for other
purposes, cache pages are made available automatically and the size of the
cache is reduced as the RAM is allocated by processes.
