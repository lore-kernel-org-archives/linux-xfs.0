Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 27 Jun 2008 02:14:42 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5R9Edrh001073
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 02:14:39 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 24C89E4FCE2
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 02:15:41 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id hmykF2AJlTfrxpWp for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 02:15:41 -0700 (PDT)
Date: Fri, 27 Jun 2008 05:15:09 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/6] Extend completions to provide XFS object flush
	requirements
Message-ID: <20080627091509.GA31148@infradead.org>
References: <1214455277-6387-1-git-send-email-david@fromorbit.com> <1214455277-6387-2-git-send-email-david@fromorbit.com> <1214512405.21035.110.camel@localhost.localdomain> <20080627022407.GB7703@parisc-linux.org> <1214537199.21035.179.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214537199.21035.179.camel@localhost.localdomain>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Daniel Walker <dwalker@mvista.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 08:26:39PM -0700, Daniel Walker wrote:
> Are you saying you want to keep semaphores? Cause I think that goes
> against the overall agenda that I've seen,

Which overall agenda? 
