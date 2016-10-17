Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52740 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934489AbcJQWHO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Oct 2016 18:07:14 -0400
Subject: Re: [xfsprogs] Update FSF address in COPYING file
References: <CAFLt3ph9uHQxNQxY3WVm020MZdgv1EjCoZ-NvyRFGW8-2R1bEw@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6b23d905-5c60-02e0-47c8-c2b6fe4d7ad6@sandeen.net>
Date: Mon, 17 Oct 2016 17:07:12 -0500
MIME-Version: 1.0
In-Reply-To: <CAFLt3ph9uHQxNQxY3WVm020MZdgv1EjCoZ-NvyRFGW8-2R1bEw@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Grozdan <neutrino8@gmail.com>, linux-xfs@vger.kernel.org

This should have a Signed-off-by: line, please.

But I thought best practice was now to leave the address out entirely,
because it may change again?

At least GPL V3 leaves it out entirely:

https://www.gnu.org/licenses/gpl.txt says:

>                     GNU GENERAL PUBLIC LICENSE
>                        Version 3, 29 June 2007
> 
>  Copyright (C) 2007 Free Software Foundation, Inc. <http://fsf.org/>
>  Everyone is permitted to copy and distribute verbatim copies
>  of this license document, but changing it is not allowed.
> 
>                             Preamble

...

Doesn't matter much to me, I guess.

Still, best practice is to send a patch with [PATCH] in the subject, i.e.:

[PATCH] xfsprogs: Update FSF address in COPYING file

a brief explanation of the change (what caught this?  where did the
new address come from?) and a Signed-off-by: line.

-Eric

On 10/17/16 4:55 PM, Grozdan wrote:
> Patch attached
> 
> -- Yours truly
> 
> 
> COPYING.diff
> 
> 
> --- xfsprogs-4.7.0/doc/COPYING	2009-12-30 23:30:13.000000000 +0100
> +++ xfsprogs-4.7.0.new/doc/COPYING	2016-10-17 23:46:05.280631426 +0200
> @@ -11,7 +11,7 @@
>  		       Version 2.1, February 1999
>  
>   Copyright (C) 1991, 1999 Free Software Foundation, Inc.
> -     59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
>   Everyone is permitted to copy and distribute verbatim copies
>   of this license document, but changing it is not allowed.
>  
> @@ -518,8 +518,8 @@
>  		    GNU GENERAL PUBLIC LICENSE
>  		       Version 2, June 1991
>  
> - Copyright (C) 1989, 1991 Free Software Foundation, Inc.
> -                       59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + Copyright (C) 1989, 1991 Free Software Foundation, Inc.,
> + 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
>   Everyone is permitted to copy and distribute verbatim copies
>   of this license document, but changing it is not allowed.
>  
> 
