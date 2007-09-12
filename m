Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Sep 2007 18:35:16 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8C1ZB4p030686
	for <xfs@oss.sgi.com>; Tue, 11 Sep 2007 18:35:12 -0700
Message-ID: <46E7424F.6030104@sandeen.net>
Date: Tue, 11 Sep 2007 20:35:11 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH SERIES] untangle spinlock macros
References: <46E6221E.803@sandeen.net> <46E73BAD.4000906@sgi.com>
In-Reply-To: <46E73BAD.4000906@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Lachlan McIlroy wrote:
> They look good to me.  There's still a few unused variables left over
> but nothing we can't fix up.

Great - and, weird - I don't see them in my tree... maybe I missed a
quilt refresh, but I don't think so... odd.

-Eric
