Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38615 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753090AbdLNQlg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Dec 2017 11:41:36 -0500
Date: Thu, 14 Dec 2017 08:41:35 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Traversing XFS mounted VM puts process in D state
Message-ID: <20171214164135.GG32616@infradead.org>
References: <CAHsD-6DNpb2+dE-yVUis35=AGOS0GoFnpT42A2vktW5HCOthMQ@mail.gmail.com>
 <20171208013819.GN4094@dastard>
 <CAHsD-6BuJe0LbnkJGT=gtqLmQQYLbpk0z9hZvAYme2OSH6LXgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHsD-6BuJe0LbnkJGT=gtqLmQQYLbpk0z9hZvAYme2OSH6LXgA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dinesh Pathak <dinesh.pathak@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, rupesh bajaj <rupesh.bajaj@gmail.com>

On Fri, Dec 08, 2017 at 02:00:19PM +0530, Dinesh Pathak wrote:
> Hi Dave, Thanks for your time. The above link only reports a similar
> bug, which has same kernel trace, which we found on internet. Our
> client machine, where traversal is done, is using CentOS.

Then you need to report it to your friendly CentOS maintainer, or
try to reproduce it with mainline.
