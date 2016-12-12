Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtprelay0161.hostedemail.com ([216.40.44.161]:39291 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752995AbcLLUum (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Dec 2016 15:50:42 -0500
Message-ID: <1481575838.1764.39.camel@perches.com>
Subject: Re: [PATCH 1/1] Fixed to codestyle
From: Joe Perches <joe@perches.com>
Date: Mon, 12 Dec 2016 12:50:38 -0800
In-Reply-To: <cbf01379-fbcb-b42e-abc1-1b368b9d6633@sandeen.net>
References: <987271481540010@web27o.yandex.ru>
         <66c68b88-e338-1d9a-b9dd-b8d858ebf349@sandeen.net>
         <1481566450.1764.23.camel@perches.com>
         <50420874-ffde-283f-f2e7-cb2ebbec1b84@sandeen.net>
         <737751481574841@web26j.yandex.ru>
         <cbf01379-fbcb-b42e-abc1-1b368b9d6633@sandeen.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Ozgur Karatas <okaratas@member.fsf.org>, "david@fromorbit.com" <david@fromorbit.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, 2016-12-12 at 14:41 -0600, Eric Sandeen wrote:
> On 12/12/16 2:34 PM, Ozgur Karatas wrote:
[]
> > Can you tell me the true code style? should use to (* uuid)? 
> > I'm learn to new and I'm newbies :)
> 
> Well, rule #1 for newbies is "code style patches aren't
> very useful, and usually are not welcomed by the project."

I'd amend that to

"newbies should only use checkpatch on files in drivers/staging/"

and are generally welcome to do exactly that in order to learn
how to submit patches appropriately before finding something
actually useful to change in other areas of the kernel.

