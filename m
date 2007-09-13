Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 13 Sep 2007 07:50:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8DEoW4p011058
	for <xfs@oss.sgi.com>; Thu, 13 Sep 2007 07:50:33 -0700
Message-ID: <46E94E37.4030505@sandeen.net>
Date: Thu, 13 Sep 2007 09:50:31 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: state of the cvs tree
References: <20070912121938.GA16870@lst.de> <46E870AB.30906@sgi.com> <20070913104000.GB3351@lst.de>
In-Reply-To: <20070913104000.GB3351@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Mark Goodwin <markgw@sgi.com>, xfs@oss.sgi.com

Christoph Hellwig wrote:

> Then I have a patch from Eric sitting in the front of my queue,
> 
> 	"[PATCH V2] refactor xfs_mountfs for clarity & stack savings"
> 
> which might be a little too big for 2.6.24, but should at least go into
> CVS ASAP.  I think Eric would be really happy to see it in 2.6.24 aswell
> because that means FC8 could actually mount xfs out of the box without
> running out of stack or something.

Yes ;-)  I've got that patch in Fedora now, but it'd be great to have it
come via upstream.

-Eric
