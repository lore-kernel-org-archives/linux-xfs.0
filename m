Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Aug 2008 18:39:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7M1cYDM024823
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 18:38:36 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 05F623BEF96
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 18:39:54 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id ORqEtRSAiHnIDsVv for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 18:39:54 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m7M1dtIF010766
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 03:39:55 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m7M1dtku010764
	for xfs@oss.sgi.com; Fri, 22 Aug 2008 03:39:55 +0200
Date: Fri, 22 Aug 2008 03:39:55 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: generic btree implementation, version 4
Message-ID: <20080822013955.GA10720@lst.de>
References: <20080807215551.GA11084@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080807215551.GA11084@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Thu, Aug 07, 2008 at 11:55:51PM +0200, Christoph Hellwig wrote:
> As the mainlinglist seems to have some problems with the large number of
> patches and I don't want to monopolize it anyway there is just this
> announcement with a link to the patches:
> 
> 	http://verein.lst.de/~hch/xfs/patches.btree.tgz

Rediffed to apply against the current tree, but without any other
patches now at th same location.
