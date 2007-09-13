Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 13 Sep 2007 03:41:37 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8DAfT4p025235
	for <xfs@oss.sgi.com>; Thu, 13 Sep 2007 03:41:33 -0700
Date: Thu, 13 Sep 2007 12:41:29 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: state of the cvs tree
Message-ID: <20070913104129.GA3548@lst.de>
References: <20070912121938.GA16870@lst.de> <46E870AB.30906@sgi.com> <20070913104000.GB3351@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070913104000.GB3351@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Goodwin <markgw@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

And there's another patch I still have in my already sent out queue for
dmapi that needs applying:

	"[PATCH] xfs_dmapi: add MODULE_ tags"

of course dmapi doesn't go to mainline so no 2.6.24 considerations here,
but getting rid of that no license specified warning would be nice.
