Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from auth-3.ukservers.net ([217.10.138.152]:55671 "EHLO
        auth-3.ukservers.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755139AbeAMNSt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 13 Jan 2018 08:18:49 -0500
Subject: Re: Growing RAID10 with active XFS filesystem
References: <f289da8f-96ec-7db4-abb1-b151d553c088@gmail.com>
 <20180108192607.GS5602@magnolia> <20180108220139.GB16421@dastard>
 <5A548D31.4000002@youngman.org.uk> <20180109222523.GJ16421@dastard>
 <85f60b96-b2ca-be84-a7f6-380b545c3ac8@turmel.org>
 <20180111030723.GU16421@dastard> <5A58B901.7080609@youngman.org.uk>
 <20180112152538.2c4d8cd4@harpe.intellique.com>
 <5A58F5FB.7000101@youngman.org.uk>
 <20180112193710.1369f4ad@harpe.intellique.com>
 <8a8f7b91-80b5-3600-a82b-b55691d0ac6b@youngman.org.uk>
 <268a13e5-5075-7fb9-caae-8ab281737ff2@fnarfbargle.com>
From: Wols Lists <antlists@youngman.org.uk>
Message-ID: <5A5A0736.7090306@youngman.org.uk>
Date: Sat, 13 Jan 2018 13:18:46 +0000
MIME-Version: 1.0
In-Reply-To: <268a13e5-5075-7fb9-caae-8ab281737ff2@fnarfbargle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brad Campbell <lists2009@fnarfbargle.com>, Emmanuel Florac <eflorac@intellique.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org

On 13/01/18 12:30, Brad Campbell wrote:
> 
> If I were to suggest an addition to the RAID wiki, it'd be to elaborate
> on the *creation* time tuning a filesystem create tool does with the
> RAID geometry, and to point out that once you grow the RAID, all
> performance bets are off. I've never met a filesystem that would break
> however.

You know me ...

If you read the wiki you'll notice I tend to be very much "pros and
cons. Choose what works for you". This write-up will be very much in the
same vein ...

Cheers,
Wol
