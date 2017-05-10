Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1605 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932223AbdEJSXP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 May 2017 14:23:15 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170510180214.16852-7-hch@lst.de>
References: <20170510180214.16852-7-hch@lst.de> <20170510180214.16852-1-hch@lst.de>
Subject: Re: [PATCH 06/16] afs: switch to use uuid_t and uuid_gen
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2703.1494440577.1@warthog.procyon.org.uk>
Date: Wed, 10 May 2017 19:22:57 +0100
Message-ID: <2704.1494440577@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: dhowells@redhat.com, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org

Christoph Hellwig <hch@lst.de> wrote:

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: David Howells <dhowells@redhat.com>
