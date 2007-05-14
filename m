Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 May 2007 16:06:07 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4EN61fB008398
	for <xfs@oss.sgi.com>; Mon, 14 May 2007 16:06:05 -0700
Date: Tue, 15 May 2007 00:39:46 +0200
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Review: Concurrent Multi-File Data Streams
Message-ID: <20070514223946.GA19487@one.firstfloor.org>
References: <p73sla1ev7o.fsf@bingen.suse.de> <000001c79544$44076ac0$0501010a@DCHATTERTONLAPTOP>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001c79544$44076ac0$0501010a@DCHATTERTONLAPTOP>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chatterton <dchatterton@aconex.com>
Cc: 'Andi Kleen' <andi@firstfloor.org>, 'xfs-dev' <xfs-dev@sgi.com>, 'xfs-oss' <xfs@oss.sgi.com>, 'David Chinner' <dgc@sgi.com>

> So yes this is designed for a workload where the number of AGs is a multiple
> of the number of streams since mixing streams in the one AG is the problem
> it tries to avoid.

Sounds like a awful special case. Is that common? 

-Andi
