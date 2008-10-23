Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Oct 2008 13:55:51 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9NKthlM007179
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 13:55:43 -0700
Date: Thu, 23 Oct 2008 16:57:28 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: deadlock with latest xfs
Message-ID: <20081023205727.GA28490@infradead.org>
References: <4900412A.2050802@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4900412A.2050802@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Oct 23, 2008 at 07:17:30PM +1000, Lachlan McIlroy wrote:
> another problem with latest xfs

Is this with the 2.6.27-based ptools/cvs tree or with the 2.6.28 based
git tree?  It does looks more like a VM issue than a XFS issue to me.
