Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48980 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751464AbcLJQmi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 10 Dec 2016 11:42:38 -0500
Date: Sat, 10 Dec 2016 17:42:36 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, RFC] xfs: take indirect blocks into accounting when
        selecting an AG
Message-ID: <20161210164236.GA3542@lst.de>
References: <1481303709-12632-1-git-send-email-hch@lst.de> <20161210061641.GQ29149@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161210061641.GQ29149@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, darrick.wong@oracle.com

Btw, is this on 4.9-rc or for-next?
