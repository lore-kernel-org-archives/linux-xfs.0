Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtprelay0078.hostedemail.com ([216.40.44.78]:53476 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752402AbdLCXUQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Dec 2017 18:20:16 -0500
Message-ID: <1512343210.6321.39.camel@perches.com>
Subject: Re: [PATCH] treewide: remove duplicate includes
From: Joe Perches <joe@perches.com>
Date: Sun, 03 Dec 2017 15:20:10 -0800
In-Reply-To: <1512337779-16842-1-git-send-email-pravin.shedge4linux@gmail.com>
References: <1512337779-16842-1-git-send-email-pravin.shedge4linux@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Pravin Shedge <pravin.shedge4linux@gmail.com>, gregkh@linuxfoundation.org, davem@davemloft.net, sstabellini@kernel.org, x86@kernel.org, mchehab@kernel.org, linux-xfs@vger.kernel.org, mcgrof@kernel.org, ast@kernel.org, shuah@kernel.org, namhyung@kernel.org, mhiramat@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, devel@driverdev.osuosl.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon, 2017-12-04 at 03:19 +0530, Pravin Shedge wrote:
> These duplicate includes have been found with scripts/checkincludes.pl but
> they have been removed manually to avoid removing false positives.

Can you list the duplicates that were not removed as well please?

