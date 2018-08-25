Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from one.firstfloor.org ([193.170.194.197]:52024 "EHLO
        one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbeHYRs5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Aug 2018 13:48:57 -0400
Date: Sat, 25 Aug 2018 07:09:51 -0700
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Trying to write to read-only block-device from XFS
Message-ID: <20180825140951.a3dsz3efwnjsj2pz@two.firstfloor.org>
References: <20180824233756.kkvmkmm5mdlx77je@two.firstfloor.org>
 <a4d32107-abc0-60d3-8306-b091fbffefd8@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4d32107-abc0-60d3-8306-b091fbffefd8@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Andi Kleen <andi@firstfloor.org>, linux-xfs@vger.kernel.org

On Fri, Aug 24, 2018 at 07:58:05PM -0500, Eric Sandeen wrote:
> On 8/24/18 6:37 PM, Andi Kleen wrote:
> > 
> > Seen this a few times now with recent kernels:
> 
> Hi Andi -
> 
> Dumb question maybe, but just to be clear -
> Was this an RO mount on an RO device, or something else?
> What type of mount was this?

Was just a normal RW partition on a normal SSD. I didn't do anything
special to make it RO.

-Andi
