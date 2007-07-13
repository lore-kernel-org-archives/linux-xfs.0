Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 13 Jul 2007 06:43:51 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6DDhjbm024917
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 06:43:47 -0700
Date: Fri, 13 Jul 2007 14:21:37 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6][TAKE7] revalidate write permissions for fallocate
Message-ID: <20070713132137.GB23256@infradead.org>
References: <20070713123816.GA18000@amitarora.in.ibm.com> <20070713124847.GC22961@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713124847.GC22961@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, tytso@mit.edu, cmm@us.ibm.com, suparna@in.ibm.com, adilger@clusterfs.com, dgc@sgi.com

On Fri, Jul 13, 2007 at 06:18:47PM +0530, Amit K. Arora wrote:
> From: David P. Quigley <dpquigl@tycho.nsa.gov>
> 
> Revalidate the write permissions for fallocate(2), in case security policy has
> changed since the files were opened.
> 
> Acked-by: James Morris <jmorris@namei.org>
> Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>

This should be merged into the main falloc patch.
