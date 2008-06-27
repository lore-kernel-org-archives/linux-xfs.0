Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 27 Jun 2008 07:36:19 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5REaEtO015787
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 07:36:14 -0700
Received: from gateway-1237.mvista.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A7148183C661
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 07:37:14 -0700 (PDT)
Received: from gateway-1237.mvista.com (homer.mvista.com [63.81.120.158]) by cuda.sgi.com with ESMTP id oRoD0KyKvjZPPNMe for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 07:37:14 -0700 (PDT)
Subject: Re: [PATCH 1/6] Extend completions to provide XFS object flush
	requirements
From: Daniel Walker <dwalker@mvista.com>
In-Reply-To: <20080627091509.GA31148@infradead.org>
References: <1214455277-6387-1-git-send-email-david@fromorbit.com>
	 <1214455277-6387-2-git-send-email-david@fromorbit.com>
	 <1214512405.21035.110.camel@localhost.localdomain>
	 <20080627022407.GB7703@parisc-linux.org>
	 <1214537199.21035.179.camel@localhost.localdomain>
	 <20080627091509.GA31148@infradead.org>
Content-Type: text/plain
Date: Fri, 27 Jun 2008 07:37:12 -0700
Message-Id: <1214577432.21035.181.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org


On Fri, 2008-06-27 at 05:15 -0400, Christoph Hellwig wrote:
> On Thu, Jun 26, 2008 at 08:26:39PM -0700, Daniel Walker wrote:
> > Are you saying you want to keep semaphores? Cause I think that goes
> > against the overall agenda that I've seen,
> 
> Which overall agenda? 

Semaphore removal ..

Daniel
