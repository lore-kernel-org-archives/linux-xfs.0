Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from auth-3.ukservers.net ([217.10.138.152]:46559 "EHLO
        auth-3.ukservers.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753865AbeAMT3Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 13 Jan 2018 14:29:25 -0500
Subject: Re: Growing RAID10 with active XFS filesystem
References: <f289da8f-96ec-7db4-abb1-b151d553c088@gmail.com>
 <20180108192607.GS5602@magnolia> <20180108220139.GB16421@dastard>
 <5A548D31.4000002@youngman.org.uk> <20180109222523.GJ16421@dastard>
 <85f60b96-b2ca-be84-a7f6-380b545c3ac8@turmel.org>
 <20180111030723.GU16421@dastard> <5A58B901.7080609@youngman.org.uk>
 <20180112152538.2c4d8cd4@harpe.intellique.com>
 <5A58F5FB.7000101@youngman.org.uk>
 <09819eb5-b342-01ca-1b96-cf5395dcd2e2@hardwarefreak.org>
From: Wol's lists <antlists@youngman.org.uk>
Message-ID: <5fd3434f-0d25-7c64-fa1b-9ed33f18df9c@youngman.org.uk>
Date: Sat, 13 Jan 2018 19:29:19 +0000
MIME-Version: 1.0
In-Reply-To: <09819eb5-b342-01ca-1b96-cf5395dcd2e2@hardwarefreak.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stan Hoeppner <stan@hardwarefreak.org>, Emmanuel Florac <eflorac@intellique.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org

On 13/01/18 00:20, Stan Hoeppner wrote:
> It's not set in stone.  If the RAID geometry changes one can specify the 
> new geometry at mount say in fstab.  New writes to the filesystem will 
> obey the new specified geometry.

Does this then update the defaults, or do you need to specify the new 
geometry every mount? Inquiring minds need to know :-)

Cheers,
Wol
