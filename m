Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A68547F59
	for <xfs@oss.sgi.com>; Sun, 20 Dec 2015 09:29:44 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 966558F8033
	for <xfs@oss.sgi.com>; Sun, 20 Dec 2015 07:29:41 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id EpuP0KbXv7ilBexI (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 20 Dec 2015 07:29:40 -0800 (PST)
Date: Sun, 20 Dec 2015 07:29:36 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFCv4 00/22] xfs-documentation: massive cleanups and add v5
	format, reverse-mapping, reflink, and dedupe support
Message-ID: <20151220152936.GA20135@infradead.org>
References: <20151219091208.15558.65013.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151219091208.15558.65013.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

On Sat, Dec 19, 2015 at 01:12:08AM -0800, Darrick J. Wong wrote:
> This patch set does the following:

I'll review the actual patches once I'll get more time, but maybe it's a
good idea to split this series and get all the cleanups and fixes in
ASAP and only land the new reverse mapping and reflink bits once the
code hits mainline?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
