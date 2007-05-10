Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 May 2007 16:07:40 -0700 (PDT)
Received: from mail.goop.org (gw.goop.org [64.81.55.164])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4AN7WfB020556
	for <xfs@oss.sgi.com>; Thu, 10 May 2007 16:07:33 -0700
Message-ID: <4643A5B2.3060906@goop.org>
Date: Thu, 10 May 2007 16:07:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
MIME-Version: 1.0
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an
 nlink problem?
References: <4642389E.4080804@goop.org> <20070509231643.GM85884050@sgi.com> <4642598E.3000607@goop.org> <20070510000119.GO85884050@sgi.com> <46426194.3040403@goop.org> <46439185.5060207@redhat.com> <464392B4.3070009@goop.org> <464393E1.3050705@redhat.com> <46439491.9010604@goop.org> <20070510225834.GF86004887@sgi.com>
In-Reply-To: <20070510225834.GF86004887@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>, xfs@oss.sgi.com

David Chinner wrote:
> Just to confirm this isn't a result of a recent change, can you reproduce
> this on a 2.6.20 or 2.6.21 kernel? (sorry if you've already done this - I've juggling
> some many things at once it's easy to forget little things).

It is the result of a recent change.  I had seen no problem until around
2.6.21-git8-11.  I will try again with a plain 2.6.21 kernel, just to
confirm.

    J
