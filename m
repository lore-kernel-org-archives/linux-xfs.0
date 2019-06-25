Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54128 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726715AbfFYKeq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 06:34:46 -0400
Date: Tue, 25 Jun 2019 03:34:46 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/10] xfs: mount-api - add fs parameter description
Message-ID: <20190625103445.GA30156@infradead.org>
References: <156134510205.2519.16185588460828778620.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156134510205.2519.16185588460828778620.stgit@fedora-28>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ian Kent <raven@themaw.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Dave Chinner <dchinner@redhat.com>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>

This is missing a cover letter to explain the point of this
series.

It adds giant amount of code for not user visible benefit.  Why would
we want this series?
