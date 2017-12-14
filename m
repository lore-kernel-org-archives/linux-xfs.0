Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:41748 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753282AbdLNQnU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Dec 2017 11:43:20 -0500
Date: Thu, 14 Dec 2017 08:43:20 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] xfs: hold xfs_buf locked between shortform->leaf
 conversion and the addition of an attribute
Message-ID: <20171214164320.GI32616@infradead.org>
References: <151270433736.12194.14709247629624139846.stgit@magnolia>
 <151270435780.12194.12104112724436317104.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151270435780.12194.12104112724436317104.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, libor.klepac@bcom.cz, bfoster@redhat.com, alex@zadarastorage.com, david@fromorbit.com

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
