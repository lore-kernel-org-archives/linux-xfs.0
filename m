Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9C9D629DFC
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 15:18:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 93721304039
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 13:18:41 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id Vyp5UKgRp7qRVlUO (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 May 2015 13:18:39 -0700 (PDT)
Date: Tue, 5 May 2015 22:18:37 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/12] xfs:Make the function,xfs_alloc_lookup_eq static
Message-ID: <20150505201837.GA11194@lst.de>
References: <1430856999-31952-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1430856999-31952-1-git-send-email-xerofoify@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Nicholas Krause <xerofoify@gmail.com>
Cc: jack@suse.cz, bfoster@redhat.com, sandeen@sandeen.net, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@lst.de

On Tue, May 05, 2015 at 04:16:28PM -0400, Nicholas Krause wrote:
> This makes the function,xfs_alloc_lookup_eq static as there are no
> calls to this function outside the definition file for this function,
> xfs_alloc.c.

Nic, please stop trolling our lists.

Thank you, and *plonk*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
