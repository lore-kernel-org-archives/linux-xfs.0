Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 20:25:46 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5R3PgYL026291
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 20:25:42 -0700
Received: from gateway-1237.mvista.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6FEC81834AA6
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 20:26:41 -0700 (PDT)
Received: from gateway-1237.mvista.com (gateway-1237.mvista.com [63.81.120.158]) by cuda.sgi.com with ESMTP id F3wjuuzidnLXNQoX for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 20:26:41 -0700 (PDT)
Subject: Re: [PATCH 1/6] Extend completions to provide XFS object flush
	requirements
From: Daniel Walker <dwalker@mvista.com>
In-Reply-To: <20080627022407.GB7703@parisc-linux.org>
References: <1214455277-6387-1-git-send-email-david@fromorbit.com>
	 <1214455277-6387-2-git-send-email-david@fromorbit.com>
	 <1214512405.21035.110.camel@localhost.localdomain>
	 <20080627022407.GB7703@parisc-linux.org>
Content-Type: text/plain
Date: Thu, 26 Jun 2008 20:26:39 -0700
Message-Id: <1214537199.21035.179.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Matthew Wilcox <matthew@wil.cx>
Cc: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org


On Thu, 2008-06-26 at 20:24 -0600, Matthew Wilcox wrote:

> 
> Then leave them as semaphores.  Really.
> 

Are you saying you want to keep semaphores? Cause I think that goes
against the overall agenda that I've seen, which is complete semaphore
removal .. If you have issues with the removal method then we could
change that ..

Daniel
