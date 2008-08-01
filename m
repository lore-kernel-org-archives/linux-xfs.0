Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Aug 2008 12:33:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m71JX4eW023720
	for <xfs@oss.sgi.com>; Fri, 1 Aug 2008 12:33:04 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DA78779F8F1
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2008 12:34:16 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 5SzCTZFbpCnClorY for <xfs@oss.sgi.com>; Fri, 01 Aug 2008 12:34:16 -0700 (PDT)
Date: Fri, 1 Aug 2008 21:34:18 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 00/21] btree cleanups and unification
Message-ID: <20080801193418.GA1263@lst.de>
References: <20080729193000.GA19104@lst.de> <20080730005338.GG13395@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730005338.GG13395@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Wed, Jul 30, 2008 at 10:53:39AM +1000, Dave Chinner wrote:
> On Tue, Jul 29, 2008 at 09:30:00PM +0200, Christoph Hellwig wrote:
> > This is the full btree unficiation based on Dave's initial patches plus
> > various cleanups.  This second versions post now contains the complete
> > btree refactoring, and passes XFSQA.
> 
> Cool. Are the first few patches unchanged from the ones I reviewed
> earlier?

As mentioned below only the trace and readahead patches changed a little
bit.
